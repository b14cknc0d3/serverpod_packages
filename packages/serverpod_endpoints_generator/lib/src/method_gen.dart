// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:code_builder/code_builder.dart';

///method generation helper
class MethodGen {
  final String modelName;
  final String queries;
  final bool requireLogin;
  final bool isSuperUser;
  MethodGen({
    required this.modelName,
    required this.queries,
    required this.requireLogin,
    required this.isSuperUser,
  });

  ///ModelName row param
  Parameter get _paramRow => Parameter(
        (c) => c
          ..name = 'row'
          ..type = refer(
            modelName,
          ),
      );

  ///Session param
  final Parameter _paramSession = Parameter(
    (c) => c
      ..name = 's'
      ..type = refer(
        'Session',
      ),
  );
  final Parameter _paramId = Parameter(
    (c) => c
      ..name = 'id'
      ..type = refer(
        'int',
      ),
  );
  final Parameter _paramSetIds = Parameter(
    (c) => c
      ..name = 'ids'
      ..type = refer(
        'Set<int>',
      ),
  );

  ///requiredLogin getter
  Method get _requiredLoginGetter => Method(
        (m) => m
          ..name = 'requireLogin'
          ..lambda = true
          ..type = MethodType.getter
          ..body = Code(requireLogin ? 'true' : 'false')
          ..annotations.add(_overrideAnnotation)
          ..returns = refer('bool'),
      );
  Method get _requiredScopeGetter => Method(
        (m) => m
          ..name = 'requiredScopes'
          ..lambda = true
          ..type = MethodType.getter
          ..body = const Code('{Scope.admin}')
          ..annotations.add(_overrideAnnotation)
          ..returns = refer('Set<Scope>'),
      );

  ///create method
  Method get _createMethod => Method(
        (m) => m
          ..modifier = MethodModifier.async
          ..annotations.add(_overrideAnnotation) //@override
          ..name = 'create'
          ..requiredParameters.addAll([
            _paramSession,
            _paramRow,
          ])
          ..body = Code('''
 try{
    return await $modelName.insert(s,row);
  }catch (e){
    throw Exception("create failed");
  }
''')
          ..returns = refer('Future<void>'),
      );

  ///update method
  Method get _updateMethod => Method(
        (m) => m
          ..name = 'update'
          ..modifier = MethodModifier.async
          ..annotations.add(_overrideAnnotation)
          ..requiredParameters.addAll([_paramSession, _paramRow])
          ..body = Code('''
try{
    return await $modelName.update(s,row);
  }catch (e){
    throw Exception("update failed");
  }
''')
          ..returns = refer('Future<bool>'),
      );

  Method get _readMethod => Method(
        (m) => m
          ..name = 'read'
          ..modifier = MethodModifier.async
          ..annotations.add(_overrideAnnotation)
          ..requiredParameters.addAll([_paramSession, _paramId])
          ..body = Code('''
try{
    return await $modelName.findById(s,id);
  }catch (e){
    throw Exception("read failed");
  }
''')
          ..returns = refer('Future<$modelName?>'),
      );

  ///delete all selected
  Method get _deleteAllSelectedMethod => Method(
        (m) => m
          ..name = 'deleteAllSelected'
          ..modifier = MethodModifier.async
          ..annotations.add(_overrideAnnotation)
          ..requiredParameters.addAll([_paramSession, _paramSetIds])
          ..body = Code('''
 try {
      await s.db.query(
          "DELETE from \${$modelName.t.tableName} WHERE \${$modelName.t.id.columnName} IN (\${ids.join(',')})");
      return 1;
    } catch (e) {
      throw Exception("deleted all failed");
    }
''')
          ..returns = refer('Future<int>'),
      );

  ///delete method
  Method get _deleteMethod => Method(
        (m) => m
          ..name = 'delete'
          ..modifier = MethodModifier.async
          ..annotations.add(_overrideAnnotation)
          ..requiredParameters.addAll([_paramSession, _paramId])
          ..body = Code('''
  try{
    return await $modelName.delete(s, where: (t)=>t.id.equals(id));
  }catch (e){
    throw Exception("deleted failed");
  }
''')
          ..returns = refer('Future<int>'),
      );

  ///get all  method
  Method get _getAllMethod => Method(
        (m) => m
          ..name = 'getAll'
          ..modifier = MethodModifier.async
          ..annotations.add(_overrideAnnotation)
          ..requiredParameters.addAll([_paramSession])
          ..optionalParameters.addAll([
            Parameter(
              (p) => p
                ..named = true
                ..name = 'limit'
                ..required = false
                ..type = refer('int')
                ..defaultTo = const Code('20'),
            ),
            Parameter(
              (p) => p
                ..named = true
                ..name = 'currentPage'
                ..required = false
                ..type = refer('int')
                ..defaultTo = const Code('1'),
            ),
          ])
          ..body = Code('''
 try{
    return await $modelName.find(
      s,
      limit: limit,
      offset: (currentPage - 1) * limit,
      orderBy: $modelName.t.id,
    );
  }catch (e){
    throw Exception("getAll failed");
  }
''')
          ..returns = refer('Future<List<$modelName>>'),
      );

  Method get _searchMethod => Method(
        (m) => m
          ..name = 'search'
          ..modifier = MethodModifier.async
          ..annotations.add(_overrideAnnotation)
          ..requiredParameters.addAll([_paramSession])
          ..optionalParameters.addAll([
            Parameter(
              (p) => p
                ..named = true
                ..name = 'limit'
                ..required = false
                ..type = refer('int')
                ..defaultTo = const Code('20'),
            ),
            Parameter(
              (p) => p
                ..named = true
                ..name = 'currentPage'
                ..required = false
                ..type = refer('int')
                ..defaultTo = const Code('1'),
            ),
            Parameter(
              (p) => p
                ..named = true
                ..name = 'queries'
                ..required = true
                ..type = refer('Map<String,dynamic>'),
            ),
          ])
          ..body = Code('''
 try{
    return await $modelName.find(
      s,
      limit: limit,
      offset: (currentPage - 1) * limit,
      orderBy: $modelName.t.id,
      where:(t){
return $queries;
      }
    );
  }catch (e){
    throw Exception("getAll failed");
  }
''')
          ..returns = refer('Future<List<$modelName>>'),
      );
  final Reference _overrideAnnotation = refer('override');
  List<Method> generate() {
    final m = <Method>[
      _requiredLoginGetter,
      _createMethod,
      _updateMethod,
      _readMethod,
      _deleteMethod,
      _getAllMethod,
      _searchMethod,
      _deleteAllSelectedMethod,
    ];
    if (isSuperUser) {
      m.add(_requiredScopeGetter);
    }
    return m;
  }
}
