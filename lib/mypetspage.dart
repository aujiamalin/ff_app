import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPetsPage extends StatefulWidget {
  const MyPetsPage({super.key});

  @override
  State<MyPetsPage> createState() => _MyPetsPageState();
}

class _MyPetsPageState extends State<MyPetsPage> {
  List<Map<String, dynamic>> pets = [];

  @override
  void initState() {
    super.initState();
    loadPets();
  }

  Future<void> savePets() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'pets_data',
      jsonEncode(pets),
    );
  }

  Future<void> loadPets() async {
    final prefs = await SharedPreferences.getInstance();

    final String? petsJson =
        prefs.getString('pets_data');

    if (petsJson != null) {
      setState(() {
        pets = List<Map<String, dynamic>>.from(
          jsonDecode(petsJson),
        );
      });
    } else {
      pets = [
        {
          'name': 'Buddy',
          'type': 'Dog',
          'age': '3',
          'image': null,
        },
        {
          'name': 'Milo',
          'type': 'Cat',
          'age': '2',
          'image': null,
        },
      ];

      savePets();
    }
  }

  Future<void> pickPetImage(int index) async {
    final ImagePicker picker = ImagePicker();

    final XFile? image =
        await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        pets[index]['image'] =
            image.path;
      });

      await savePets();
    }
  }

  void addPet() {
    TextEditingController nameController =
        TextEditingController();

    TextEditingController typeController =
        TextEditingController();

    TextEditingController ageController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Pet"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              TextField(
                controller:
                    nameController,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Pet Name",
                ),
              ),
              TextField(
                controller:
                    typeController,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Pet Type",
                ),
              ),
              TextField(
                controller:
                    ageController,
                keyboardType:
                    TextInputType
                        .number,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Pet Age",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
            child:
                const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                pets.add({
                  'name':
                      nameController
                          .text,
                  'type':
                      typeController
                          .text,
                  'age':
                      ageController
                          .text,
                  'image': null,
                });
              });

              await savePets();

              Navigator.pop(
                context,
              );
            },
            child:
                const Text("Add"),
          ),
        ],
      ),
    );
  }

  void editPet(int index) {
    TextEditingController nameController =
        TextEditingController(
      text: pets[index]['name'],
    );

    TextEditingController typeController =
        TextEditingController(
      text: pets[index]['type'],
    );

    TextEditingController ageController =
        TextEditingController(
      text: pets[index]['age'],
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:
            const Text("Edit Pet"),
        content:
            SingleChildScrollView(
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              TextField(
                controller:
                    nameController,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Pet Name",
                ),
              ),
              TextField(
                controller:
                    typeController,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Pet Type",
                ),
              ),
              TextField(
                controller:
                    ageController,
                keyboardType:
                    TextInputType
                        .number,
                decoration:
                    const InputDecoration(
                  labelText:
                      "Pet Age",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
            child:
                const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                pets[index]['name'] =
                    nameController
                        .text;

                pets[index]['type'] =
                    typeController
                        .text;

                pets[index]['age'] =
                    ageController
                        .text;
              });

              await savePets();

              Navigator.pop(
                context,
              );
            },
            child:
                const Text("Save"),
          ),
        ],
      ),
    );
  }

  void deletePet(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Delete Pet",
        ),
        content: const Text(
          "Are you sure you want to delete this pet?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
            child:
                const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                pets.removeAt(
                  index,
                );
              });

              await savePets();

              Navigator.pop(
                context,
              );
            },
            child:
                const Text("Delete"),
          ),
        ],
      ),
    );
  }

  IconData getPetIcon(
    String type,
  ) {
    if (type.toLowerCase() ==
        'dog') {
      return Icons.pets;
    }

    if (type.toLowerCase() ==
        'cat') {
      return Icons.cruelty_free;
    }

    return Icons.favorite;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(
        0xFFF8FAFC,
      ),
      appBar: AppBar(
        title:
            const Text("My Pets"),
        backgroundColor:
            Colors.orange,
        foregroundColor:
            Colors.white,
      ),
      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            Colors.orange,
        onPressed: addPet,
        child: const Icon(
          Icons.add,
        ),
      ),
      body: pets.isEmpty
          ? const Center(
              child: Text(
                "No Pets Found",
              ),
            )
          : ListView.builder(
              itemCount:
                  pets.length,
              itemBuilder:
                  (context,
                      index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal:
                        15,
                    vertical:
                        8,
                  ),
                  child: ListTile(
                    leading:
                        GestureDetector(
                      onTap: () {
                        pickPetImage(
                          index,
                        );
                      },
                      child:
                          CircleAvatar(
                        radius:
                            28,
                        backgroundColor:
                            Colors.orange,
                        backgroundImage:
                            pets[index]['image'] !=
                                    null
                                ? FileImage(
                                    File(
                                      pets[index]['image'],
                                    ),
                                  )
                                : null,
                        child: pets[index]
                                    [
                                    'image'] ==
                                null
                            ? Icon(
                                getPetIcon(
                                  pets[index]
                                      [
                                      'type'],
                                ),
                                color: Colors
                                    .white,
                              )
                            : null,
                      ),
                    ),
                    title: Text(
                      pets[index]
                          ['name'],
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    subtitle:
                        Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          "${pets[index]['type']} • ${pets[index]['age']} years old",
                        ),
                        const SizedBox(
                          height:
                              5,
                        ),
                        const Text(
                          "Tap photo to change pet image",
                          style:
                              TextStyle(
                            fontSize:
                                11,
                            color: Colors
                                .grey,
                          ),
                        ),
                      ],
                    ),
                    trailing:
                        Row(
                      mainAxisSize:
                          MainAxisSize
                              .min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(
                            Icons
                                .edit,
                            color: Colors
                                .blue,
                          ),
                          onPressed:
                              () {
                            editPet(
                              index,
                            );
                          },
                        ),
                        IconButton(
                          icon:
                              const Icon(
                            Icons
                                .delete,
                            color: Colors
                                .red,
                          ),
                          onPressed:
                              () {
                            deletePet(
                              index,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

