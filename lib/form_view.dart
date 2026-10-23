import 'dart:io';

import 'package:dynamic_job_application_form/widgets/cusotm_elevated_button.dart';
import 'package:dynamic_job_application_form/widgets/custom_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormView extends StatefulWidget {
  const FormView({super.key});

  @override
  State<FormView> createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController jobCategoryController = TextEditingController();
  TextEditingController coverLetterController = TextEditingController();

  File? profileImage;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  DateTime? pickedDate;
  Future<void> selectDate() async {
    pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dateOfBirthController.text =
            "${pickedDate?.day}/${pickedDate?.month}/${pickedDate?.year}";
      });
    }
  }

  bool isAdult(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age >= 18;
  }

  Map<String, List<String>> jopCategorySkills = {
    "Software Developer": ["Flutter", "Dart", "Firebase", "Python"],
    "UI/UX Designer": ["Figma", "Adobe XD", "Photoshop"],
    "Data Analyst": ["Excel", "SQL", "Python", "Power BI"],
    "Project Manager": ["Leadership", "Planning", "Communication"],
  };
  String? selectedCategory;
  List<String> selectedSkills = [];

  bool applicationDone = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: applicationDone == false
            ? Text("Jop Application")
            : Text("Your Application"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: applicationDone == false
            ? Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: profileImage != null
                          ? FileImage(profileImage!)
                          : null,
                      child: profileImage == null
                          ? Icon(
                              Icons.person_3_outlined,
                              size: 55,
                              color: CupertinoColors.systemBlue,
                            )
                          : null,
                    ),
                  ),

                  Text(
                    "Apply for a Jop",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Fill in your details to get started",
                    style: TextStyle(color: CupertinoColors.systemGrey),
                  ),
                  Align(
                    alignment: AlignmentGeometry.center,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusGeometry.circular(12),
                        color: Colors.white,
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Personal Information"),
                            Divider(),
                            Text("Full Name"),
                            Custemtextformfield(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This Field is required';
                                }
                                return null;
                              },
                              controller: fullNameController,
                              hintText: "Enter project name",
                              obscureText: false,
                            ),
                            Text("Email Address"),
                            Custemtextformfield(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This Field is required';
                                }
                                return null;
                              },
                              controller: emailAddressController,
                              hintText: "example@gmail.com",
                              obscureText: false,
                            ),
                            Text("Phone Number"),
                            Custemtextformfield(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This Field is required';
                                }
                                return null;
                              },
                              controller: phoneNumberController,
                              hintText: "Enter Your phone Number",
                              obscureText: false,
                            ),
                            Text("Date of Birth"),
                            Custemtextformfield(
                              onTap: selectDate,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This Field is required';
                                }
                                if (!isAdult(pickedDate!)) {
                                  return "you must be at least 18 years old";
                                }
                                return null;
                              },
                              controller: dateOfBirthController,
                              hintText: "Select your birth date",

                              obscureText: false,
                            ),
                            SizedBox(height: 10),
                            Text("Job Details"),
                            Divider(),
                            Text("Job Category"),
                            DropdownButtonFormField(
                              initialValue: selectedCategory,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              hint: Text("Select a job category"),
                              items: jopCategorySkills.keys.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                  selectedSkills.clear();
                                });
                              },
                            ),
                            Text("Your Skills"),
                            selectedCategory != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ...jopCategorySkills[selectedCategory]!
                                          .map((skill) {
                                            return Material(
                                              color: Colors.transparent,
                                              child: CheckboxListTile(
                                                value: selectedSkills.contains(
                                                  skill,
                                                ),
                                                title: Text(skill),
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (value == true) {
                                                      selectedSkills.add(skill);
                                                    } else {
                                                      selectedSkills.remove(
                                                        skill,
                                                      );
                                                    }
                                                  });
                                                },
                                              ),
                                            );
                                          }),
                                    ],
                                  )
                                : SizedBox.shrink(),
                            Text("Cover Letter"),
                            Custemtextformfield(
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'This Field is required';
                                }
                                return null;
                              },
                              controller: coverLetterController,
                              hintText:
                                  "Tell us why you are a good fit for this position...",
                              obscureText: false,
                            ),

                            Text("Profile Photo"),

                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadiusGeometry.circular(12),
                              ),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  debugPrint("Image Picker tapped");
                                  await pickImage();
                                },
                                child: profileImage == null
                                    ? Column(
                                        spacing: 5,
                                        children: [
                                          Icon(
                                            Icons.add_photo_alternate_outlined,
                                            color: Colors.blueAccent,
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "Choose an Image \nfrom gallery",
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "JPG or PNG",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        "Image uploaded",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            Customelevatedbutton(
                              buttonText: "Submit Application",
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Success")),
                                  );
                                  setState(() {
                                    applicationDone = true;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : null,
                        child: profileImage == null
                            ? Icon(
                                Icons.person_3_outlined,
                                size: 55,
                                color: CupertinoColors.systemBlue,
                              )
                            : null,
                      ),
                    ),
                    Text(
                      "Personal Information",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Text("Full Name: ${fullNameController.text}"),
                    Text("Email Address: ${emailAddressController.text}"),
                    Text("Phone Number: ${phoneNumberController.text}"),
                    Text("Date Of Birth: ${dateOfBirthController.text}"),
                    Text(
                      "Job Details",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Text("Job Category : $selectedCategory"),
                    Text(
                      "Your Skills: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...List.generate(
                      selectedSkills.length,
                      (index) => Text(selectedSkills[index]),
                    ),
                    Divider(),
                    Text("Cover Letter: \n ${coverLetterController.text}"),
                  ],
                ),
              ),
      ),
    );
  }
}
