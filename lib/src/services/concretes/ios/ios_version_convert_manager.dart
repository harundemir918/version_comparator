import '../../../models/entities/ios_version_entity_model.dart';
import '../../../utils/enums/error_message.dart';
import '../../../utils/results/data_result.dart';
import '../../abstracts/version_convert_service.dart';

class IosVersionConvertManager extends VersionConvertService<IosVersionEntityModel> {
  @override
  DataResult<String> convert(IosVersionEntityModel entity) {
    if (entity.storeVersion.isEmpty) {
      return DataResult.byErrorMessageEnum(error: ErrorMessage.versionNotMatch);
    }

    return DataResult.success(data: entity.storeVersion);
  }
}
