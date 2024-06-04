import 'package:sqflite/sqflite.dart';
import 'package:climate_wise/models/models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    //Path de dónde se almacena la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'heatstroke.db');
    print(path);

    //Crear base de datos
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute('''
  CREATE TABLE Paciente(
    id INTEGER PRIMARY KEY,
    nombre TEXT,
    p_apellido TEXT,
    s_apellido TEXT,
    edad INTEGER,
    peso INTEGER,
    actividad INTEGER
  );
  
''');
      },
    );
  }

  Future<int> nuevoPaciente(PacienteModel nuevoScan) async {
    final db = await database;
    final res = await db.insert('Paciente', nuevoScan.toJson());

    return res;
  }

  Future<PacienteModel?> getPacienteById(int id) async {
    final db = await database;
    final res = await db.query(
      'Paciente',
      where: 'id = ?',
      whereArgs: [id],
    );

    return res.isNotEmpty ? PacienteModel.fromJson(res.first) : null;
  }

  Future<int> updatePaciente(PacienteModel nuevoScan) async {
    final db = await database;
    final res = await db.update(
      'Paciente',
      nuevoScan.toJson(),
      where: 'id = ?',
      whereArgs: [nuevoScan.id],
    );
    return res;
  }

  Future<int> deleteRentaById(int id) async {
    final db = await database;
    final res = await db.delete('Paciente', where: 'id=?', whereArgs: [id]);
    print(res);
    return res;
  }

  Future<int> deleteAllUser() async {
    final db = await database;
    final res = await db.delete('Paciente');
    print(res);
    return res;
  }
}
