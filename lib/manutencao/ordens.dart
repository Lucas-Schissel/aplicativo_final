import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'dart:html';

final String ordensTabela = "";
final String idOrden = "idOrden";
final String problemaOrden = "problemaOrden";
final String causaOrden = "causaOrden";
final String solucaoOrden = "solucaoOrden";
final String comentariosOrden = "comentariosOrden";

class Ordens{
  static final Ordens _instance = Ordens.internal();

  factory Ordens() => _instance;

  Ordens.internal();

  Database _db;

  Future<Database> get db async{
    if (_db != null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }
    
    Future<Database> initDb() async{

      final databasesPath = await getDatabasesPath();

      final path = join(databasesPath, "manutencao.db");

      return openDatabase(path, version: 1, onCreate:(Database db, int newerVersion) async{
        await db.execute("CREATE TABLE $ordensTabela($idOrden INTEGER PRIMARY KEY,$problemaOrden TEXT $causaOrden TEXT,$solucaoOrden TEXT,$comentariosOrden TEXT");
      });
    }

    Future<Orden> buscarOrdens(int id ) async {
      Database dbOrdens = await db;

      List<Map> maps = await dbOrdens.query(
      ordensTabela,
      columns:[idOrden,problemaOrden,causaOrden,solucaoOrden,comentariosOrden],
      where: "$idOrden = ?",
      whereArgs: [id]
      );

      if(maps.length > 0){
        return Orden.fromMap(maps.first);

      }else{
        return null;
      }
     
    }

    Future<Orden> alterarOrdens(int id ) async {
      Database dbOrdens = await db;

      List<Map> maps = await dbOrdens.query(
      ordensTabela,
      columns:[idOrden,problemaOrden,causaOrden,solucaoOrden,comentariosOrden],
      where: "$idOrden = ?",
      whereArgs: [id]
      );

      
     
    }

    Future<List> todasAsOrdens() async {
      Database dbOrdens = await db;
      List listaMap = await dbOrdens.rawQuery("SELECT & FROM $ordensTabela");
      List<Orden> listaOrdens = List();
      for(Map m in listaMap){
        listaOrdens.add(Orden.fromMap(m));
      }

      return listaOrdens;
    }

    Future close() async{
      Database dbOrdens = await db;
      dbOrdens.close();
    }
 

  
}

class Orden{
  int id;
  String numeracao;
  String problema;
  String causa;
  String solucao;
  String comentarios;
 
  Orden.fromMap(Map map){
    id = map[idOrden];
    problema = map[problemaOrden];
    causa = map[causaOrden];
    solucao = map[solucaoOrden];
    comentarios = map[comentariosOrden];
  }

  Map toMap(){
    Map<String, dynamic> map ={
      problemaOrden : problema,
      causaOrden: causa,
      solucaoOrden: solucao,
      comentariosOrden: comentarios,
    };

  if(id != null){
    map[idOrden] = id;
  }
  return map;

  }

  @override
  String toString(){
    return "Usuario:(id: $id)";
  }

}