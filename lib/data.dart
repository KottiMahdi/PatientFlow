// Class to store patient information
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

// Sample list of patients
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
];

// Class to store agenda item information
class AgendaItem {
  final String title;
  final String date;
  final String description;

  AgendaItem({
    required this.title,
    required this.date,
    required this.description,
  });
}

// List of agenda items
List<AgendaItem> agendaItems = [
  AgendaItem(
    title: "Team Meeting",
    date: "2024-11-01",
    description: "Monthly team meeting to discuss project updates.",
  ),
  AgendaItem(
    title: "Code Review",
    date: "2024-11-05",
    description: "Reviewing code submissions from the latest sprint.",
  ),
  AgendaItem(
    title: "Design Session",
    date: "2024-11-10",
    description: "Brainstorming session for new design features.",
  ),
];
