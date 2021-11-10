import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'dart:html';

final String usuariosTabela = "";
final String idUsuario = "idUsuario";
final String nomeUsuario = "nomeUsuario";
final String senhaUsuario = "senhaUsuario";
final String telefoneUsuario = "telefoneUsuario";
final String setorUsuario = "setorUsuario";
final String statusUsuario = "statusUsuario";

class UsuarioLogin{
  static final UsuarioLogin _instance = UsuarioLogin.internal();

  factory UsuarioLogin() => _instance;

  UsuarioLogin.internal();

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
        await db.execute("CREATE TABLE $usuariosTabela($idUsuario INTEGER PRIMARY KEY,$nomeUsuario TEXT $senhaUsuario TEXT,$telefoneUsuario TEXT,$setorUsuario TEXT,$statusUsuario TEXT)");
      });
    }

    Future<Usuario> buscarUsuario(int id ) async {
      Database dbUsuarios = await db;

      List<Map> maps = await dbUsuarios.query(
      usuariosTabela,
      columns:[idUsuario,nomeUsuario,telefoneUsuario,setorUsuario,statusUsuario],
      where: "$idUsuario = ?",
      whereArgs: [id]
      );

      if(maps.length > 0){
        return Usuario.fromMap(maps.first);

      }else{
        return null;
      }
     
    }

    Future close() async{
      Database dbUsuarios = await db;
      dbUsuarios.close();
    }
 

  
}

class Usuario{
  int id;
  String nome;
  String senha;
  String telefone;
  String setor;
  String status;

  Usuario.fromMap(Map map){
    id = map[idUsuario];
    nome = map[nomeUsuario];
    senha = map[senhaUsuario];
    telefone = map[telefoneUsuario];
    setor = map[setorUsuario];
    status = map[statusUsuario];
  }

  Map toMap(){
    Map<String, dynamic> map ={
      nomeUsuario : nome,
      senhaUsuario: senha,
      telefoneUsuario: telefone,
      setorUsuario: setor,
      statusUsuario: status,
    };

  if(id != null){
    map[idUsuario] = id;
  }
  return map;

  }

  @override
  String toString(){
    return "Usuario:(id: $id, nome: $nome)";
  }

}