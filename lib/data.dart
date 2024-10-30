class Patient {
  final String name;
  final String groupSanguin;
  final String dateNaiss;
  final int age;
  final String adresse;
  final String etatCivil;
  final String genre;
  final String tel;
  final String telWhatsApp;
  final String email;

  Patient({
    required this.name,
    required this.groupSanguin,
    required this.dateNaiss,
    required this.age,
    required this.adresse,
    required this.etatCivil,
    required this.genre,
    required this.tel,
    required this.telWhatsApp,
    required this.email,
  });
}
final List<Patient> patients = [
  Patient(
    name: 'Nesrine Naouar Ep Ben Youssef',
    groupSanguin: 'A positif',
    dateNaiss: '12/05/1986 00:00:00',
    age: 38,
    adresse: 'Ariana',
    etatCivil: 'Femme',
    genre: 'Femme',
    tel: '96221487',
    telWhatsApp: '96221487',
    email: '',
  ),
  Patient(
    name: 'Mayssem Charwel',
    groupSanguin: 'A positif',
    dateNaiss: '12/05/1986 00:00:00',
    age: 38,
    adresse: 'Tunis',
    etatCivil: 'Homme',
    genre: 'Femme',
    tel: '96221487',
    telWhatsApp: '96221487',
    email: '',
  ),
  Patient(
    name: 'Ali Ben Amor',
    groupSanguin: 'O négatif',
    dateNaiss: '23/07/1975 00:00:00',
    age: 49,
    adresse: 'Sousse',
    etatCivil: 'Homme',
    genre: 'Homme',
    tel: '98123456',
    telWhatsApp: '98123456',
    email: 'ali.benamor@gmail.com',
  ),
  Patient(
    name: 'Fatma Kallel',
    groupSanguin: 'B positif',
    dateNaiss: '05/03/1992 00:00:00',
    age: 32,
    adresse: 'Nabeul',
    etatCivil: 'Femme',
    genre: 'Femme',
    tel: '99123456',
    telWhatsApp: '99123456',
    email: 'fatma.kallel@hotmail.com',
  ),
  Patient(
    name: 'Mohamed Trabelsi',
    groupSanguin: 'AB positif',
    dateNaiss: '18/09/1980 00:00:00',
    age: 44,
    adresse: 'Monastir',
    etatCivil: 'Homme',
    genre: 'Homme',
    tel: '96123456',
    telWhatsApp: '96123456',
    email: 'mohamed.trabelsi@yahoo.com',
  ),
  Patient(
    name: 'Samira Fekih',
    groupSanguin: 'O positif',
    dateNaiss: '10/11/1990 00:00:00',
    age: 34,
    adresse: 'Sfax',
    etatCivil: 'Femme',
    genre: 'Femme',
    tel: '97123456',
    telWhatsApp: '97123456',
    email: 'samira.fekih@example.com',
  ),
  Patient(
    name: 'Hassan Bouazizi',
    groupSanguin: 'A négatif',
    dateNaiss: '15/02/1983 00:00:00',
    age: 41,
    adresse: 'Gabès',
    etatCivil: 'Homme',
    genre: 'Homme',
    tel: '95123456',
    telWhatsApp: '95123456',
    email: 'hassan.bouazizi@gmail.com',
  ),
  Patient(
    name: 'Leila Messaoud',
    groupSanguin: 'B négatif',
    dateNaiss: '08/08/1978 00:00:00',
    age: 46,
    adresse: 'Bizerte',
    etatCivil: 'Femme',
    genre: 'Femme',
    tel: '94123456',
    telWhatsApp: '94123456',
    email: 'leila.messaoud@hotmail.com',
  ),
  Patient(
    name: 'Amine Hachani',
    groupSanguin: 'AB négatif',
    dateNaiss: '03/04/1994 00:00:00',
    age: 30,
    adresse: 'Kairouan',
    etatCivil: 'Homme',
    genre: 'Homme',
    tel: '92123456',
    telWhatsApp: '92123456',
    email: 'amine.hachani@yahoo.com',
  ),
  Patient(
    name: 'Salma Ben Romdhane',
    groupSanguin: 'O négatif',
    dateNaiss: '22/11/1987 00:00:00',
    age: 37,
    adresse: 'Mahdia',
    etatCivil: 'Femme',
    genre: 'Femme',
    tel: '91123456',
    telWhatsApp: '91123456',
    email: 'salma.benromdhane@example.com',
  ),
  Patient(
    name: 'Rafik Gharbi',
    groupSanguin: 'A positif',
    dateNaiss: '27/06/1969 00:00:00',
    age: 55,
    adresse: 'Sidi Bouzid',
    etatCivil: 'Homme',
    genre: 'Homme',
    tel: '90123456',
    telWhatsApp: '90123456',
    email: 'rafik.gharbi@example.com',
  ),
  Patient(
    name: 'Khadija Ben Salem',
    groupSanguin: 'B positif',
    dateNaiss: '14/12/1995 00:00:00',
    age: 28,
    adresse: 'Kasserine',
    etatCivil: 'Femme',
    genre: 'Femme',
    tel: '88123456',
    telWhatsApp: '88123456',
    email: 'khadija.bensalem@example.com',
  ),
];

class AgendaItem {
  String title;
  String date;
  String description;

  AgendaItem({required this.title, required this.date, required this.description});
}



