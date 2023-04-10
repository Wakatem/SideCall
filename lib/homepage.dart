import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getFolderPath() async {
  Directory temp = await getTemporaryDirectory();
  Directory currentFolder = Directory(temp.path + '\\SideCall');
  bool folderExists = await currentFolder.exists();

  if (!folderExists) {
    currentFolder = await currentFolder.create();
  }
  return currentFolder.path;
}

Future<File> getDataFile(String type) async {
  final path = await getFolderPath();
  String dataPath = '$path\\' + type + ".txt";
  File dataFile = File(dataPath);
  bool fileExists = await dataFile.exists();

  if (!fileExists) {
    dataFile = await dataFile.create();
    final content = (type == 'SDuser' ? 'ABC' : ''); // assign default username
    dataFile.writeAsString(content);
  } else {
    debugPrint('$type exists!');
  }

  return dataFile;
}

void storeRoomName(String roomName) async {
  //read rooms
  File data = await getDataFile('SDrooms');
  var content = await data.readAsString();

  //update and store rooms
  if (content.isEmpty) {
    content += roomName;
    await data.writeAsString(content);
  } else if (!content.contains(roomName)) {
    content += "," + roomName;
    await data.writeAsString(content);
  }
}

Future<List<String>> getRooms() async {
  File data = await getDataFile('SDrooms');
  var content = await data.readAsString();

  if (content.isNotEmpty) {
    return content.split(',');
  }

  return List.empty();
}

void updateUsername(String newUsername) async {
  //read user data
  File data = await getDataFile('SDuser');
  await data.writeAsString(newUsername);
}

Future<String> getUsername() async {
  File data = await getDataFile('SDuser');
  var content = await data.readAsString();
  return content;
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String username = "";
  bool editUsername = false;
  bool saveRoom = false;
  var rooms = [];

  TextEditingController usernameController = TextEditingController();
  TextEditingController roomController = TextEditingController();

  void setData() async {
    var roomsTemp = await getRooms();
    var usernameTemp = await getUsername();
    setState(() {
      rooms = roomsTemp;
      username = usernameTemp;
      usernameController.text = usernameTemp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: const Color.fromRGBO(16, 24, 38, 1),
          body: Row(
            children: [
              SizedBox(
                  height: double.infinity,
                  width: 180,
                  child: rooms.isEmpty
                      ? const Center(
                          child: Text(
                            'No saved rooms to display',
                            style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      : ListView(
                          children: rooms
                              .map((room) => RoomCard(roomKey: room))
                              .toList(),
                        )),
              const VerticalDivider(
                color: Colors.white30,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      'assets/ghost.png',
                      width: 150,
                      height: 150,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 60.0),
                          child: SizedBox(
                            width: 200,
                            child: TextField(
                              decoration: const InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                hintText: 'Username',
                                hintStyle: TextStyle(color: Colors.white60),
                                disabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white24)),
                              ),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 30),
                              textAlign: TextAlign.center,
                              controller: usernameController,
                              maxLines: 1,
                              enabled: editUsername,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 20.0),
                          child: ElevatedButton(
                            child: editUsername
                                ? const Text('Save')
                                : const Text('Edit'),
                            onPressed: () => setState(() {
                              editUsername = !editUsername;
                              //when saving
                              if (!editUsername)
                                updateUsername(usernameController.text);
                            }),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 500,
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      border: GradientOutlineInputBorder(
                                          gradient: LinearGradient(colors: [
                                        Color.fromRGBO(39, 59, 93, 1),
                                        Color.fromRGBO(112, 56, 168, 1)
                                      ])),
                                      enabledBorder: GradientOutlineInputBorder(
                                          gradient: LinearGradient(colors: [
                                        Color.fromRGBO(39, 59, 93, 1),
                                        Color.fromRGBO(112, 56, 168, 1)
                                      ])),
                                      hintText: 'Room Name',
                                      hintStyle:
                                          TextStyle(color: Colors.white60),
                                    ),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                    controller: roomController,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 10,
                              left: 665,
                              child: Column(
                                children: [
                                  const Text(
                                    'Save Room',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13.0),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: FlutterSwitch(
                                      value: saveRoom,
                                      onToggle: (val) => setState(() {
                                        saveRoom = val;
                                      }),
                                      height: 17,
                                      width: 45,
                                      toggleSize: 14,
                                      inactiveText: 'Save room',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 28.0),
                          child: ElevatedButton(
                            style: const ButtonStyle(
                                fixedSize: MaterialStatePropertyAll<Size>(
                                    Size(140, 30)),
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color.fromRGBO(44, 22, 65, 1))),
                            child: const Text('Join',
                                style: TextStyle(fontSize: 15)),
                            onPressed: () async {
                              saveRoom
                                  ? storeRoomName(roomController.text)
                                  : null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.roomKey});

  final String? roomKey;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Card(
        color: const Color.fromRGBO(27, 41, 65, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text(
                '#$roomKey',
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Join'),
            ),
          ],
        ),
      ),
    );
  }
}
