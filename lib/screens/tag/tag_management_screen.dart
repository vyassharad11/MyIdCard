import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_di_card/screens/contact/contact_notes.dart';
import 'package:my_di_card/utils/colors/colors.dart';

class TagManagementScreen extends StatefulWidget {
  const TagManagementScreen({super.key});

  @override
  _TagManagementScreenState createState() => _TagManagementScreenState();
}

class _TagManagementScreenState extends State<TagManagementScreen> {
  List<String> tags = [
    "Tag no.1",
    "Tag no.2",
    "Tag no.3",
    "Tag no.4",
    "Tag no.5",
    "Tag no.6",
    "Tag no.7",
    "Tag no.1",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoursUtils.background,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text(
          'Tags Management',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10, top: 6),
            padding: const EdgeInsets.only(right: 0, top: 6, bottom: 6),
            child: ClipOval(
              child: Material(
                color: Colors.blue, // Button color
                child: InkWell(
                  splashColor: Colors.blue, // Splash color
                  onTap: () {
                    _showBottomSheet(context);
                  },
                  child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height / 1.5,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 0,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 13),
                child: Text(
                  'Tags',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    thickness: 1,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                  itemCount: tags.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100,
                            padding: const EdgeInsets.all(
                                10), // Add padding inside the container

                            decoration: BoxDecoration(
                              color: Colors.grey[200], // Light background color
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                            ),
                            child: Text(
                              tags[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black, // Text color
                                fontSize: 14,
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (String value) {
                              switch (value) {
                                case 'Edit':
                                  _editTag(index);
                                  break;
                                case 'Delete':
                                  _deleteTag(index);
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'Edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Delete',
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                    // ListTile(
                    //   title:
                    //   // Text(tags[index]),
                    //   trailing:
                    // );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add Tag Input Field
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear_rounded))
                ],
              ),
              const Text(
                "Add Tag",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light white color
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Add Tag',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Text(
                "Add Contacts",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              // Search Input Field
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Light white color
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Contact Information
              ListTile(
                contentPadding: const EdgeInsets.only(right: 0),
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/images/user_dummy.png"),
                ),
                title: const Text(
                  "Janice Schneider",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black),
                ),
                subtitle: const Text("Sr. Product Solutions Manager"),
                trailing: Container(
                  child: ClipOval(
                    child: Material(
                      color: Colors.blue, // Button color
                      child: InkWell(
                        splashColor: Colors.blue, // Splash color
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (builder) => AddContactNotes()));
                        },
                        child: const SizedBox(
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to handle editing a tag
  void _editTag(int index) {
    TextEditingController controller = TextEditingController(text: tags[index]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Tag"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter new tag name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                tags[index] = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  // Function to handle deleting a tag
  void _deleteTag(int index) {
    setState(() {
      tags.removeAt(index);
    });
  }
}
