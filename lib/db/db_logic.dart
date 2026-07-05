import 'package:mockingbird/db/db_objectbox.dart';
import 'package:mockingbird/objectbox.g.dart';

class DBLogic {
  final Store _store;
  const DBLogic.test(this._store); //for unit test
  DBLogic():this.test(DBObjectBox().store);
  
}
