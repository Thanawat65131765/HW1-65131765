import 'dart:io';

void main() {
  Hotel hotel = Hotel();

  // Add multiple rooms at the start
  addMultipleRooms(hotel, 101, 105, 'Single', 100.0);

  while (true) {
    print('\nHotel Management System');
    print('1. Add Room');
    print('2. Remove Room');
    print('3. Register Guest');
    print('4. Book Room');
    print('5. Cancel Room Booking');
    print('6. List Rooms');
    print('7. List Guests');
    print('8. Exit');
    print('Enter your choice: ');

    String? choice = stdin.readLineSync();

    if (choice == null || choice.isEmpty) {
      print('Invalid choice. Please try again.');
      continue;
    }

    switch (choice) {
      case '1':
        addRoom(hotel);
        break;
      case '2':
        removeRoom(hotel);
        break;
      case '3':
        registerGuest(hotel);
        break;
      case '4':
        bookRoom(hotel);
        break;
      case '5':
        cancelRoom(hotel);
        break;
      case '6':
        listRooms(hotel);
        break;
      case '7':
        listGuests(hotel);
        break;
      case '8':
        exit(0);
      default:
        print('Invalid choice. Please try again.');
    }
  }
}

void addRoom(Hotel hotel) {
  print('Enter room number: ');
  String? roomNumber = stdin.readLineSync();
  if (roomNumber == null || roomNumber.isEmpty) {
    print('Room number cannot be null or empty.');
    return;
  }

  print('Enter room type (Single, Double, Suite): ');
  String? roomType = stdin.readLineSync()?.toLowerCase();
  if (roomType == null || !['single', 'double', 'suite'].contains(roomType)) {
    print('Invalid room type. Please enter Single, Double, or Suite.');
    return;
  }

  print('Enter room price: ');
  String? priceInput = stdin.readLineSync();
  double? price = double.tryParse(priceInput ?? '');
  if (price == null) {
    print('Invalid price.');
    return;
  }

  Room room = Room(roomNumber, roomType, price, false);
  hotel.addRoom(room);
  print('Room added successfully.');
}

void removeRoom(Hotel hotel) {
  print('Enter room number to remove: ');
  String? roomNumber = stdin.readLineSync();
  if (roomNumber == null || roomNumber.isEmpty) {
    print('Room number cannot be null or empty.');
    return;
  }

  Room? room = hotel.getRoom(roomNumber);
  if (room != null) {
    hotel.removeRoom(room);
    print('Room removed successfully.');
  } else {
    print('Room not found.');
  }
}

void registerGuest(Hotel hotel) {
  print('Enter guest name: ');
  String? name = stdin.readLineSync();
  if (name == null || name.isEmpty) {
    print('Guest name cannot be null or empty.');
    return;
  }

  print('Enter guest ID: ');
  String? guestId = stdin.readLineSync();
  if (guestId == null || guestId.isEmpty) {
    print('Guest ID cannot be null or empty.');
    return;
  }

  Guest guest = Guest(name, guestId, []);
  hotel.registerGuest(guest);
  print('Guest registered successfully.');
}

void bookRoom(Hotel hotel) {
  print('Enter guest ID: ');
  String? guestId = stdin.readLineSync();
  if (guestId == null || guestId.isEmpty) {
    print('Guest ID cannot be null or empty.');
    return;
  }

  print('Enter room number to book: ');
  String? roomNumber = stdin.readLineSync();
  if (roomNumber == null || roomNumber.isEmpty) {
    print('Room number cannot be null or empty.');
    return;
  }

  hotel.bookRoom(guestId, roomNumber);
}

void cancelRoom(Hotel hotel) {
  print('Enter guest ID: ');
  String? guestId = stdin.readLineSync();
  if (guestId == null || guestId.isEmpty) {
    print('Guest ID cannot be null or empty.');
    return;
  }

  print('Enter room number to cancel booking: ');
  String? roomNumber = stdin.readLineSync();
  if (roomNumber == null || roomNumber.isEmpty) {
    print('Room number cannot be null or empty.');
    return;
  }

  hotel.cancelRoom(guestId, roomNumber);
}

void listRooms(Hotel hotel) {
  hotel.listRooms();
}

void listGuests(Hotel hotel) {
  hotel.listGuests();
}

void addMultipleRooms(Hotel hotel, int start, int end, String roomType, double price) {
  roomType = roomType.toLowerCase();
  if (!['single', 'double', 'suite'].contains(roomType)) {
    print('Invalid room type. Please enter Single, Double, or Suite.');
    return;
  }
  for (int i = start; i <= end; i++) {
    Room room = Room(i.toString(), roomType, price, false);
    hotel.addRoom(room);
  }
  print('Rooms from $start to $end added successfully.');
}

class Room {
  String _roomNumber;
  String _roomType;
  double _price;
  bool _isBooked;

  Room(this._roomNumber, this._roomType, this._price, this._isBooked);

  String get roomNumber => _roomNumber;
  String get roomType => _roomType;
  double get price => _price;
  bool get isBooked => _isBooked;

  void bookRoom() {
    if (!_isBooked) {
      _isBooked = true;
      print('Room $_roomNumber has been booked.');
    } else {
      print('Room $_roomNumber is already booked.');
    }
  }

  void cancelBooking() {
    if (_isBooked) {
      _isBooked = false;
      print('Booking for room $_roomNumber has been cancelled.');
    } else {
      print('Room $_roomNumber is not booked yet.');
    }
  }
}

class Guest {
  String _name;
  String _guestId;
  List<Room> _bookedRooms;

  Guest(this._name, this._guestId, this._bookedRooms);

  String get name => _name;
  String get guestId => _guestId;
  List<Room> get bookedRooms => _bookedRooms;

  void bookRoom(Room room) {
    if (!room.isBooked) {
      room.bookRoom();
      _bookedRooms.add(room);
      print('Guest $_name has booked room ${room.roomNumber}.');
    } else {
      print('Room ${room.roomNumber} is already booked.');
    }
  }

  void cancelRoom(Room room) {
    if (room.isBooked) {
      room.cancelBooking();
      _bookedRooms.remove(room);
      print('Guest $_name has cancelled booking for room ${room.roomNumber}.');
    } else {
      print('Room ${room.roomNumber} is not booked.');
    }
  }

  void printBookedRooms() {
    if (_bookedRooms.isEmpty) {
      print('No rooms booked.');
    } else {
      for (Room room in _bookedRooms) {
        print('Room Number: ${room.roomNumber}, Type: ${room.roomType}, Price: ${room.price}');
      }
    }
  }
}

class Hotel {
  List<Room> _rooms = [];
  List<Guest> _guests = [];

  List<Room> get rooms => _rooms;
  List<Guest> get guests => _guests;

  void addRoom(Room room) {
    _rooms.add(room);
  }

  void removeRoom(Room room) {
    _rooms.remove(room);
  }

  void registerGuest(Guest guest) {
    _guests.add(guest);
  }

  Room? getRoom(String roomNumber) {
  for (Room room in _rooms) {
    if (room.roomNumber == roomNumber) {
      return room;
    }
  }
  return null; // Return null if room is not found
  }

  Guest? getGuest(String guestId) {
  for (Guest guest in _guests) {
    if (guest.guestId == guestId) {
      return guest;
    }
  }
  return null; // Return null if guest is not found
  }
  void bookRoom(String guestId, String roomNumber) {
    Guest? guest = getGuest(guestId);
    Room? room = getRoom(roomNumber);

    if (guest != null && room != null && !room.isBooked) {
      guest.bookRoom(room);
      print("Room booked successfully.");
    } else {
      print("Booking failed. Either guest or room not found, or room is already booked.");
    }
  }

  void cancelRoom(String guestId, String roomNumber) {
    Guest? guest = getGuest(guestId);
    Room? room = getRoom(roomNumber);

    if (guest != null && room != null && room.isBooked) {
      guest.cancelRoom(room);
      print("Booking cancelled successfully.");
    } else {
      print("Cancellation failed. Either guest or room not found, or room is not booked.");
    }
  }

  void listRooms() {
    if (_rooms.isEmpty) {
      print('No rooms available.');
    } else {
      for (Room room in _rooms) {
        print('Room Number: ${room.roomNumber}, Type: ${room.roomType}, Price: ${room.price}, Is Booked: ${room.isBooked}');
      }
    }
  }

  void listGuests() {
    if (_guests.isEmpty) {
      print('No guests registered.');
    } else {
      for (Guest guest in _guests) {
        print('Guest Name: ${guest.name}, Guest ID: ${guest.guestId}');
        guest.printBookedRooms();
      }
    }
  }
}
