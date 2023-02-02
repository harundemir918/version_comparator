import '../../models/entities/entity_model.dart';
import '../../utils/results/data_result.dart';

abstract class JsonToVersionResponseService<TData extends EntityModel<TData>> {
  DataResult<String> convert(TData entity);
}
