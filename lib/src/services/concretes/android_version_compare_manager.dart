import '../../models/entities/empty_entity_model.dart';
import '../../models/entities/store_model.dart';
import '../../models/parameters/get_data_service_parameter_model.dart';
import '../../models/version_response_model.dart';
import '../../utils/constants/constants.dart';
import '../../utils/results/data_result.dart';
import '../abstracts/json_to_version_response_service.dart';
import '../abstracts/remote_data_service.dart';
import '../abstracts/version_compare_service.dart';
import 'android_json_to_version_response_manager.dart';
import 'http_remote_data_manager.dart';

class AndroidVersionCompareManager extends VersionCompareService {
  AndroidVersionCompareManager({required this.dataService, required this.jsonToResponseService});

  AndroidVersionCompareManager.httpService({JsonToVersionResponseService? jsonToVersionResponseService})
      : dataService = HttpRemoteDataManager(),
        jsonToResponseService = jsonToVersionResponseService ?? AndroidJsonToVersionResponseManager();

  @override
  BaseStoreModel get store => StoreModel.android();

  @override
  final RemoteDataService dataService;

  @override
  final JsonToVersionResponseService jsonToResponseService;

  @override
  Future<DataResult<VersionResponseModel>> getVersion() async {
    final appVersionResult = await getCurrentAppVersion();
    if (appVersionResult.isNotSuccess) return DataResult.error(message: appVersionResult.message);

    final bundleIdResult = await getBundleId();
    if (bundleIdResult.isNotSuccess) return DataResult.error(message: bundleIdResult.message);

    final parameter = GetDataServiceParameterModel<EmptyEntityModel>(
      baseUrl: store.baseUrl,
      endpoint: store.endpoint,
      parseModel: EmptyEntityModel.empty(),
      query: 'bundleId=${bundleIdResult.data}',
    );

    final response = await dataService.getData(parameter);
    if (response.isNotSuccess || response.data == null) {
      return DataResult.error(message: response.message);
    }

    final versionResult = jsonToResponseService.convert(response.data!);
    if (versionResult.isNotSuccess) {
      return DataResult.error(message: versionResult.message);
    }

    return DataResult.success(
      data: VersionResponseModel(
        appVersion: appVersionResult.data ?? kEmpty,
        storeVersion: versionResult.data ?? kEmpty,
        updateLink: parameter.getUrl(),
      ),
    );
  }
}
