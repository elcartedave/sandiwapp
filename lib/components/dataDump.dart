import 'package:sandiwapp/models/announcementModel.dart';
import 'package:sandiwapp/models/formsModel.dart';
import 'package:sandiwapp/models/messageModel.dart';
import 'package:sandiwapp/models/userModel.dart';

final List<Announcement> announcements = [
  Announcement(
      title: "Announcement Title 1",
      content:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet",
      date: DateTime.now(),
      committee: "General"),
  Announcement(
    title: "Announcement Title 2 HGAHAHAHAHAHHAHAHAH",
    content:
        "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    date: DateTime.parse('2020-02-27T14:00:00-08:00'),
    committee: "General",
  ),
  Announcement(
    title: "Announcement Title 3",
    content:
        "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    date: DateTime.parse(
      '2021-02-27T14:00:00-08:00',
    ),
    committee: "General",
  ),
  Announcement(
    title: "Announcement Title 4",
    content:
        "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    date: DateTime.parse('2002-02-27T14:00:00-08:00'),
    committee: "General",
  ),
  Announcement(
    title: "Announcement Title 5",
    content:
        "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    date: DateTime.parse('2012-02-27T14:00:00-08:00'),
    committee: "General",
  ),
  Announcement(
    title: "Announcement Title 6",
    content:
        "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    date: DateTime.parse('2015-02-27T14:00:00-08:00'),
    committee: "General",
  ),
  Announcement(
    title: "Announcement Title 7",
    content:
        "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    date: DateTime.parse('2015-02-27T14:20:00-08:00'),
    committee: "General",
  ),
  Announcement(
    title: "Announcement 1",
    committee: "eduk",
    date: DateTime.parse('2002-02-27T14:00:00-08:00'),
    content:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis ut mi fringilla, porttitor metus in, egestas nibh. Nullam convallis, leo non venenatis posuere, dolor elit pulvinar felis, id fringilla metus odio at urna.",
  ),
  Announcement(
    title: "Announcement 2",
    committee: "fin",
    date: DateTime.parse('2002-02-27T14:00:00-08:00'),
    content:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis ut mi fringilla, porttitor metus in, egestas nibh. Nullam convallis, leo non venenatis posuere, dolor elit pulvinar felis, id fringilla metus odio at urna.",
  )
];

List<MyUser> sampleUsers = [
  MyUser(
    name: 'John Doe',
    nickname: 'Johnny',
    birthday: 'January 1, 2000',
    age: '24',
    contactno: '123-456-7890',
    collegeAddress: '123 College St, City, Country',
    homeAddress: '456 Home St, City, Country',
    email: 'john.doe@example.com',
    password: 'password123',
    sponsor: 'Sponsor A',
    batch: 'Batch 1',
    confirmed: true,
    paid: true,
    balance: '0',
    merit: '10',
    demerit: '0',
    position: 'President',
    photoUrl: '',
    lupon: 'Lupon ng Pananalapi',
    paymentProofUrl: "",
    acknowledged: false,
  ),
  MyUser(
    name: 'Jane Smith',
    nickname: 'Janey',
    birthday: 'February 2, 1999',
    age: '25',
    contactno: '987-654-3210',
    collegeAddress: '789 College Ave, City, Country',
    homeAddress: '321 Home Ave, City, Country',
    email: 'jane.smith@example.com',
    password: 'password456',
    sponsor: 'Sponsor B',
    batch: 'Batch 2',
    confirmed: false,
    paid: false,
    balance: '100',
    merit: '5',
    demerit: '2',
    position: 'Vice President',
    photoUrl:
        'https://t4.ftcdn.net/jpg/06/70/98/09/360_F_670980905_FEZa7ncVspPUpkRrIdZdLGnfanLuoCnN.jpg',
    lupon: 'Lupon ng Edukasyon at Pananaliksik',
    paymentProofUrl: "",
    acknowledged: false,
  ),
  MyUser(
    name: 'Alice Johnson',
    nickname: 'Ali',
    birthday: 'March 3, 1998',
    age: '26',
    contactno: '555-555-5555',
    collegeAddress: '123 University Rd, City, Country',
    homeAddress: '789 Suburb Rd, City, Country',
    email: 'alice.johnson@example.com',
    password: 'password789',
    sponsor: 'Sponsor C',
    batch: 'Batch 3',
    confirmed: true,
    paid: true,
    balance: '50',
    merit: '7',
    demerit: '1',
    position: 'Secretary',
    photoUrl: '',
    lupon: 'Lupon ng Kasapian',
    paymentProofUrl: "",
    acknowledged: false,
  ),
  MyUser(
    name: 'Bob Brown',
    nickname: 'Bobby',
    birthday: 'April 4, 2001',
    age: '23',
    contactno: '111-222-3333',
    collegeAddress: '456 Campus Blvd, City, Country',
    homeAddress: '123 Rural St, City, Country',
    email: 'bob.brown@example.com',
    password: 'password101',
    sponsor: 'Sponsor D',
    batch: 'Batch 4',
    confirmed: true,
    paid: false,
    balance: '200',
    merit: '12',
    demerit: '3',
    position: 'Treasurer',
    photoUrl:
        'https://marketplace.canva.com/EAFcni82eUk/1/0/900w/canva-pink-aesthetic-kitty-cat-phone-wallpaper-VlmkOE1IQ0Y.jpg',
    lupon: 'Lupon ng Pamamahayag at Publikasyon',
    paymentProofUrl: "",
    acknowledged: false,
  ),
  MyUser(
    name: 'Charlie Davis',
    nickname: 'Charlie',
    birthday: 'May 5, 1997',
    age: '27',
    contactno: '222-333-4444',
    collegeAddress: '789 Academic Ln, City, Country',
    homeAddress: '456 Urban Rd, City, Country',
    email: 'charlie.davis@example.com',
    password: 'password202',
    sponsor: 'Sponsor E',
    batch: 'Batch 5',
    confirmed: true,
    paid: true,
    balance: '0',
    merit: '15',
    demerit: '1',
    position: 'Member',
    photoUrl: 'https://images2.alphacoders.com/133/1335809.png',
    lupon: 'Lupon ng Pamamahayag at Publikasyon',
    paymentProofUrl: "",
    acknowledged: false,
  ),
  MyUser(
    name: 'Diana Evans',
    nickname: 'Di',
    birthday: 'June 6, 1996',
    age: '28',
    contactno: '333-444-5555',
    collegeAddress: '123 Education St, City, Country',
    homeAddress: '789 Country Rd, City, Country',
    email: 'diana.evans@example.com',
    password: 'password303',
    sponsor: 'Sponsor F',
    batch: 'Batch 6',
    confirmed: false,
    paid: true,
    balance: '30',
    merit: '9',
    demerit: '0',
    position: 'Member',
    photoUrl: 'https://wallpapers.com/images/featured/cat-g9rdx9uk2425fip2.jpg',
    lupon: 'Lupon ng Ugnayang Panlabas',
    paymentProofUrl: "",
    acknowledged: false,
  ),
  MyUser(
    name: 'Edward Franklin',
    nickname: 'Ed',
    birthday: 'July 7, 2002',
    age: '22',
    contactno: '444-555-6666',
    collegeAddress: '456 Scholar Rd, City, Country',
    homeAddress: '123 Mountain St, City, Country',
    email: 'edward.franklin@example.com',
    password: 'password404',
    sponsor: 'Sponsor G',
    batch: 'Batch 7',
    confirmed: true,
    paid: true,
    balance: '10',
    merit: '8',
    demerit: '2',
    position: 'Member',
    photoUrl:
        'https://pixbuster.com/images/Pixbuster-Desktop-Wallpaper-4K-018.jpg',
    lupon: 'Lupon ng Pananalapi',
    paymentProofUrl: "",
    acknowledged: false,
  ),
  MyUser(
    name: 'Fiona Green',
    nickname: 'Fi',
    birthday: 'August 8, 2003',
    age: '21',
    contactno: '555-666-7777',
    collegeAddress: '789 Learning Blvd, City, Country',
    homeAddress: '456 Forest Rd, City, Country',
    email: 'fiona.green@example.com',
    password: 'password505',
    sponsor: 'Sponsor H',
    batch: 'Batch 8',
    confirmed: false,
    paid: false,
    balance: '50',
    merit: '6',
    demerit: '1',
    position: 'Member',
    photoUrl:
        'https://www.shutterstock.com/image-photo/happy-puppy-welsh-corgi-14-600nw-2270841247.jpg',
    lupon: 'Lupon ng Kasapian',
    paymentProofUrl: "",
    acknowledged: false,
  ),
  MyUser(
    name: 'George Harris',
    nickname: 'George',
    birthday: 'September 9, 1995',
    age: '29',
    contactno: '666-777-8888',
    collegeAddress: '123 Academic Ave, City, Country',
    homeAddress: '789 Seaside Rd, City, Country',
    email: 'george.harris@example.com',
    password: 'password606',
    sponsor: 'Sponsor I',
    batch: 'Batch 9',
    confirmed: true,
    paid: true,
    balance: '0',
    merit: '11',
    demerit: '0',
    position: 'Member',
    photoUrl:
        'https://cdn.pixabay.com/photo/2023/08/18/15/02/dog-8198719_640.jpg',
    lupon: 'Lupon ng Edukasyon at Pananaliksik',
    paymentProofUrl: "",
    acknowledged: false,
  ),
  MyUser(
    name: 'Hannah Ingram',
    nickname: 'Hanna',
    birthday: 'October 10, 2000',
    age: '24',
    contactno: '777-888-9999',
    collegeAddress: '456 University Blvd, City, Country',
    homeAddress: '123 Coastal St, City, Country',
    email: 'hannah.ingram@example.com',
    password: 'password707',
    sponsor: 'Sponsor J',
    batch: 'Batch Obra Maestra Panday PIlak HAHA',
    confirmed: true,
    paid: false,
    balance: '100',
    merit: '13',
    demerit: '3',
    position: 'Member',
    photoUrl:
        'https://marketplace.canva.com/EAFhwfMq3ds/1/0/1600w/canva-colorful-cute-cats-illustration-desktop-wallpaper-KBBZLdpjLcM.jpg',
    lupon: 'Lupon ng Edukasyon at Pananaliksik',
    paymentProofUrl: "",
    acknowledged: false,
  )
];

final List<Message> messages = [
  Message(
    sender: "Juan Dela Cruz",
    receiver: "Maria Makiling",
    date: DateTime.parse('2002-02-27T14:00:00-08:00'),
    content:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis ut mi fringilla, porttitor metus in, egestas nibh. Nullam convallis, leo non venenatis posuere, dolor elit pulvinar felis, id fringilla metus odio at urna.",
  ),
  Message(
    date: DateTime.now(),
    sender: "Juan Dela Cruz II",
    receiver: "Mariang Banga",
    content:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis ut mi fringilla, porttitor metus in, egestas nibh. Nullam convallis, leo non venenatis posuere, dolor elit pulvinar felis, id fringilla metus odio at urna.",
  ),
  Message(
    sender: "Juan Dela Cruz III",
    receiver: "Maria Makiling II",
    date: DateTime.parse('2023-02-27T14:00:00-08:00'),
    content:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis ut mi fringilla, porttitor metus in, egestas nibh. Nullam convallis, leo non venenatis posuere, dolor elit pulvinar felis, id fringilla metus odio at urna.",
  ),
  // Add more messages as needed
];

List<MyForm> forms = [
  MyForm(url: "url", date: DateTime.now(), title: "Form 1"),
  MyForm(url: "url", date: DateTime.now(), title: "Form 2"),
  MyForm(url: "url", date: DateTime.now(), title: "Form 3"),
];
