import 'package:fava/models/request.dart';
import 'package:fava/models/user.dart';

class MockAuthData {
  static UserModel? currentUser;
  
  static void initializeWithDefaultUser() {
    currentUser = mockUsers.first;
  }
  
  static void setCurrentUser(UserModel user) {
    currentUser = user;
  }
  
  static void clearCurrentUser() {
    currentUser = null;
  }
}

/// Mock user database (in-memory list)
final List<UserModel> mockUsers = [
  UserModel(
    id: "1",
    fullName: "Test User",
    email: "test@email.com",
    phoneNumber: "(555) 555-1234",
    password: "Test1234",
    locationEnabled: false,
  ),
  UserModel(
    id: "2",
    fullName: "Sarah Johnson",
    email: "sarah.johnson@gmail.com",
    phoneNumber: "(555) 123-4567",
    password: "SecurePass123",
    locationEnabled: true,
  ),
  UserModel(
    id: "3",
    fullName: "Michael Chen",
    email: "mchen@outlook.com",
    phoneNumber: "(555) 987-6543",
    password: "MyPassword456",
    locationEnabled: true,
  ),
  UserModel(
    id: "4",
    fullName: "Emma Rodriguez",
    email: "emma.rodriguez@yahoo.com",
    phoneNumber: "(555) 456-7890",
    password: "Emma2024!",
    locationEnabled: false,
  ),
  UserModel(
    id: "5",
    fullName: "David Wilson",
    email: "dwilson@icloud.com",
    phoneNumber: "(555) 321-0987",
    password: "DavidSecure789",
    locationEnabled: true,
  ),
  UserModel(
    id: "6",
    fullName: "Jessica Martinez",
    email: "jessica.m@protonmail.com",
    phoneNumber: "(555) 654-3210",
    password: "Jessica123Safe",
    locationEnabled: false,
  ),
  UserModel(
    id: "7",
    fullName: "Alex Thompson",
    email: "alexthompson@gmail.com",
    phoneNumber: "(555) 789-0123",
    password: "AlexPass2024",
    locationEnabled: true,
  ),
  UserModel(
    id: "8",
    fullName: "Lisa Park",
    email: "lpark@students.university.edu",
    phoneNumber: "(555) 012-3456",
    password: "StudentLife123",
    locationEnabled: true,
  ),
  UserModel(
    id: "9",
    fullName: "Ryan Foster",
    email: "ryan.foster@company.com",
    phoneNumber: "(555) 345-6789",
    password: "WorkSecure456",
    locationEnabled: false,
  ),
  UserModel(
    id: "10",
    fullName: "Maria Garcia",
    email: "maria.garcia@email.com",
    phoneNumber: "(555) 567-8901",
    password: "MariaStrong789",
    locationEnabled: true,
  ),
  UserModel(
    id: "11",
    fullName: "James Taylor",
    email: "jtaylor@techcorp.com",
    phoneNumber: "(555) 678-9012",
    password: "TechGuy2024!",
    locationEnabled: false,
  ),
  UserModel(
    id: "12",
    fullName: "Sophie Brown",
    email: "sophie.brown@freelancer.com",
    phoneNumber: "(555) 890-1234",
    password: "FreelanceLife123",
    locationEnabled: true,
  ),
  UserModel(
    id: "13",
    fullName: "Noah Williams",
    email: "noah.w@startup.io",
    phoneNumber: "(555) 901-2345",
    password: "StartupGrind456",
    locationEnabled: true,
  ),
  UserModel(
    id: "14",
    fullName: "Olivia Davis",
    email: "olivia.davis@consultant.com",
    phoneNumber: "(555) 012-9876",
    password: "ConsultSafe789",
    locationEnabled: false,
  ),
  UserModel(
    id: "15",
    fullName: "Ethan Miller",
    email: "ethan.miller@designer.studio",
    phoneNumber: "(555) 123-8765",
    password: "DesignPass2024",
    locationEnabled: true,
  ),
  UserModel(
    id: "16",
    fullName: "Ava Johnson",
    email: "ava.johnson@marketing.agency",
    phoneNumber: "(555) 234-7654",
    password: "MarketingPro123",
    locationEnabled: false,
  ),
  UserModel(
    id: "17",
    fullName: "Mason Lee",
    email: "mason.lee@developer.dev",
    phoneNumber: "(555) 345-6543",
    password: "CodeSecure456",
    locationEnabled: true,
  ),
  UserModel(
    id: "18",
    fullName: "Isabella White",
    email: "isabella.white@teacher.edu",
    phoneNumber: "(555) 456-5432",
    password: "TeacherLife789",
    locationEnabled: true,
  ),
  UserModel(
    id: "19",
    fullName: "Lucas Anderson",
    email: "lucas.anderson@health.care",
    phoneNumber: "(555) 567-4321",
    password: "HealthCare2024!",
    locationEnabled: false,
  ),
  UserModel(
    id: "20",
    fullName: "Mia Thompson",
    email: "mia.thompson@artist.studio",
    phoneNumber: "(555) 678-3210",
    password: "ArtisticPass123",
    locationEnabled: true,
  ),
];


/// Mock user request database (in-memory list)
final List<RequestData> mockRequests = [
  // RIDE REQUESTS
  RequestData(
    userName: 'Sarah John',
    timeAgo: '5 hours ago',
    requestTitle: 'Need a ride to downtown for Interview',
    requestDescription: 'I have a job interview at 2pm and would really appreciate a ride to the downtown area. Can pay for gas and your time!',
    distance: '0.5 miles away',
    price: '\$5',
    requestType: 'Ride',
  ),
  RequestData(
    userName: 'Michael Chen',
    timeAgo: '2 hours ago',
    requestTitle: 'Airport pickup needed',
    requestDescription: 'Flight lands at 8:30pm tonight. Need a ride from LAX to Beverly Hills. Heavy luggage included!',
    distance: '2.1 miles away',
    price: '\$25',
    requestType: 'Ride',
  ),
  RequestData(
    userName: 'Jessica Martinez',
    timeAgo: '30 minutes ago',
    requestTitle: 'Ride to grocery store',
    requestDescription: 'My car is in the shop and I need to do some grocery shopping. Can help carry bags!',
    distance: '0.8 miles away',
    price: '\$8',
    requestType: 'Ride',
  ),

  // Errand REQUESTS
  RequestData(
    userName: 'David Wilson',
    timeAgo: '1 hour ago',
    requestTitle: 'Pick up prescription from pharmacy',
    requestDescription: 'I\'m stuck at work and the pharmacy closes at 6pm. Can someone please pick up my prescription?',
    distance: '1.2 miles away',
    price: '\$10',
    requestType: 'Errand',
  ),
  RequestData(
    userName: 'Emma Thompson',
    timeAgo: '3 hours ago',
    requestTitle: 'Grocery shopping assistance',
    requestDescription: 'Need someone to pick up groceries from Whole Foods. I have a detailed shopping list ready!',
    distance: '1.8 miles away',
    price: '\$15',
    requestType: 'Errand',
  ),
  RequestData(
    userName: 'Alex Rodriguez',
    timeAgo: '6 hours ago',
    requestTitle: 'Post office run',
    requestDescription: 'Need to mail some important documents before 5pm. Package is ready to go, just need drop-off.',
    distance: '0.9 miles away',
    price: '\$7',
    requestType: 'Errand',
  ),

  // Favor REQUESTS
  RequestData(
    userName: 'Lisa Park',
    timeAgo: '45 minutes ago',
    requestTitle: 'Help moving furniture',
    requestDescription: 'Moving to a new apartment tomorrow. Need help with some heavy furniture. Pizza and drinks provided!',
    distance: '1.5 miles away',
    price: '\$20',
    requestType: 'Favor',
  ),
  RequestData(
    userName: 'Ryan Foster',
    timeAgo: '4 hours ago',
    requestTitle: 'Dog walking while at work',
    requestDescription: 'Working late tonight and my Golden Retriever needs a walk. He\'s very friendly and well-behaved!',
    distance: '0.7 miles away',
    price: '\$12',
    requestType: 'Favor',
  ),
  RequestData(
    userName: 'Maria Garcia',
    timeAgo: '7 hours ago',
    requestTitle: 'Plant watering for vacation',
    requestDescription: 'Going out of town for a week. Need someone to water my plants every other day. Simple instructions provided.',
    distance: '1.1 miles away',
    price: '\$25',
    requestType: 'Favor',
  ),

  // OTHER REQUESTS
  RequestData(
    userName: 'James Taylor',
    timeAgo: '20 minutes ago',
    requestTitle: 'Tech support for elderly parent',
    requestDescription: 'My mom needs help setting up her new tablet. Looking for someone patient and tech-savvy.',
    distance: '2.3 miles away',
    price: '\$30',
    requestType: 'Others',
  ),
  RequestData(
    userName: 'Sophie Brown',
    timeAgo: '2 hours ago',
    requestTitle: 'Photography for small event',
    requestDescription: 'Having a small birthday party for my daughter. Need someone to take some nice photos of the celebration.',
    distance: '1.6 miles away',
    price: '\$50',
    requestType: 'Others',
  ),
  RequestData(
    userName: 'Noah Williams',
    timeAgo: '8 hours ago',
    requestTitle: 'Tutoring help for math',
    requestDescription: 'My son needs help with algebra homework. Looking for someone good with math to help for an hour.',
    distance: '0.6 miles away',
    price: '\$40',
    requestType: 'Others',
  ),

  // MORE RIDE REQUESTS
  RequestData(
    userName: 'Olivia Davis',
    timeAgo: '1 day ago',
    requestTitle: 'Weekend beach trip carpool',
    requestDescription: 'Planning to go to Santa Monica beach this Saturday. Looking for someone to share gas costs!',
    distance: '1.9 miles away',
    price: '\$15',
    requestType: 'Ride',
  ),
  RequestData(
    userName: 'Ethan Miller',
    timeAgo: '12 hours ago',
    requestTitle: 'Late night ride home',
    requestDescription: 'Working late shift and need a ride home around 11pm. Uber is too expensive in my area.',
    distance: '1.3 miles away',
    price: '\$18',
    requestType: 'Ride',
  ),

  // MORE Errand
  RequestData(
    userName: 'Ava Johnson',
    timeAgo: '5 hours ago',
    requestTitle: 'Dry cleaning pickup',
    requestDescription: 'Need someone to pick up my dry cleaning before they close at 7pm. Have the receipt ready.',
    distance: '1.0 miles away',
    price: '\$8',
    requestType: 'Errand',
  ),
  RequestData(
    userName: 'Mason Lee',
    timeAgo: '9 hours ago',
    requestTitle: 'Hardware store shopping',
    requestDescription: 'Need specific tools for a home project. Have a detailed list with part numbers. Home Depot run needed.',
    distance: '2.2 miles away',
    price: '\$12',
    requestType: 'Errand',
  ),

  // MORE Favor
  RequestData(
    userName: 'Isabella White',
    timeAgo: '3 hours ago',
    requestTitle: 'Babysitting for date night',
    requestDescription: 'Need a reliable babysitter for our 8-year-old daughter this Friday evening. She\'s very well-behaved!',
    distance: '0.4 miles away',
    price: '\$60',
    requestType: 'Favor',
  ),
  RequestData(
    userName: 'Lucas Anderson',
    timeAgo: '6 hours ago',
    requestTitle: 'Garden maintenance help',
    requestDescription: 'Need help with weeding and basic garden maintenance. Tools provided, just need some muscle power!',
    distance: '1.7 miles away',
    price: '\$35',
    requestType: 'Favor',
  ),

  // MORE OTHERS
  RequestData(
    userName: 'Mia Thompson',
    timeAgo: '4 hours ago',
    requestTitle: 'Language practice partner',
    requestDescription: 'Learning Spanish and need someone to practice conversation with. Native speaker preferred!',
    distance: '1.4 miles away',
    price: '\$25',
    requestType: 'Others',
  ),
  RequestData(
    userName: 'Benjamin Clark',
    timeAgo: '10 hours ago',
    requestTitle: 'Computer repair assistance',
    requestDescription: 'My laptop won\'t start up properly. Need someone knowledgeable with computers to take a look.',
    distance: '0.9 miles away',
    price: '\$45',
    requestType: 'Others',
  ),
];

