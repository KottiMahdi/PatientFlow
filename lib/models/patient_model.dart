// lib/models/patient_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final String id;
  final String name;
  final String prenom;
  final String cin;
  final String age;
  final String dateNaiss;
  final String codePostal;
  final String numeroAssurance;
  final String? genre;
  final String? etatCivil;
  final String? nationalite;
  final String adresse;
  final String ville;
  final String tel;
  final String telWhatsApp;
  final String email;
  final String dernierRdv;
  final String prochainRdv;
  final String? groupSanguin;
  final String? assurant;
  final String? assurance;
  final String? relation;
  final String? profession;
  final String pays;
  final String adressePar;
  final DateTime? createdAt;

  Patient({
    required this.id,
    required this.name,
    required this.prenom,
    required this.cin,
    required this.age,
    required this.dateNaiss,
    required this.codePostal,
    required this.numeroAssurance,
    this.genre,
    this.etatCivil,
    this.nationalite,
    required this.adresse,
    required this.ville,
    required this.tel,
    required this.telWhatsApp,
    required this.email,
    required this.dernierRdv,
    required this.prochainRdv,
    this.groupSanguin,
    this.assurant,
    this.assurance,
    this.relation,
    this.profession,
    required this.pays,
    required this.adressePar,
    this.createdAt,
  });

  // Factory constructor to create a Patient from a Firestore document
  factory Patient.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Patient(
      id: doc.id,
      name: data['name'] ?? '',
      prenom: data['prenom'] ?? '',
      cin: data['CIN'] ?? '',
      age: data['age'] ?? '',
      dateNaiss: data['dateNaiss'] ?? '',
      codePostal: data['codePostal'] ?? '',
      numeroAssurance: data['numeroAssurance'] ?? '',
      genre: data['genre'],
      etatCivil: data['etatCivil'],
      nationalite: data['nationalite'],
      adresse: data['adresse'] ?? '',
      ville: data['ville'] ?? '',
      tel: data['tel'] ?? '',
      telWhatsApp: data['telWhatsApp'] ?? '',
      email: data['email'] ?? '',
      dernierRdv: data['Dernier RDV'] ?? '',
      prochainRdv: data['Prochain RDV'] ?? '',
      groupSanguin: data['groupSanguin'],
      assurant: data['assurant'],
      assurance: data['assurance'],
      relation: data['relation'],
      profession: data['profession'],
      pays: data['pays'] ?? '',
      adressePar: data['adressee'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert Patient to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'prenom': prenom,
      'CIN': cin,
      'age': age,
      'dateNaiss': dateNaiss,
      'codePostal': codePostal,
      'numeroAssurance': numeroAssurance,
      'genre': genre,
      'etatCivil': etatCivil,
      'nationalite': nationalite,
      'adresse': adresse,
      'ville': ville,
      'tel': tel,
      'telWhatsApp': telWhatsApp,
      'email': email,
      'Dernier RDV': dernierRdv,
      'Prochain RDV': prochainRdv,
      'groupSanguin': groupSanguin,
      'assurant': assurant,
      'assurance': assurance,
      'relation': relation,
      'profession': profession,
      'pays': pays,
      'adressee': adressePar,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}