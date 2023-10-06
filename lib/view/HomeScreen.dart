import 'dart:io';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

import 'package:appdevelopmentapplications_aaysha/view/drawing_canvas/widgets/image_text.dart';

import '../main.dart';
import 'drawing_canvas/models/text_info.dart';
import 'drawing_canvas/widgets/default_button.dart';
import 'home.dart';
class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();
  TextEditingController creatorText = TextEditingController();
  List<TextInfo> texts = [];
  int currentIndex = 0;
File? imageFile;
  File _file = File("zz");
  Uint8List webImage = Uint8List(10);
  Future _pickImage() async {
  if(!kIsWeb){
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

    // WEB
    else if (kIsWeb) {
      final ImagePicker pickedImage = ImagePicker();
      XFile? image = await pickedImage.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          _file = File("zz");
          webImage = f;
        });
      } else {
       ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No file selected")));
      }
    } else {
     // showToast("Permission not granted");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Permission not granted")));
    }
  }
  Future _cropImage() async {
    if (imageFile != null ) {
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: imageFile!.path ,
          aspectRatioPresets:
          [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],

          uiSettings: [
          AndroidUiSettings(
          toolbarTitle: 'Crop',
          cropGridColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
          IOSUiSettings(title: 'Crop')
    ]);

    if (cropped != null) {
    setState(() {
    imageFile = File(cropped.path);
    });
    }
  }

  }
  void _clearImage() {
    setState(() {
      imageFile = null;

    });
  }
  void saveFile(Uint8List bytes, String extension) async {
    if (kIsWeb) {
      html.AnchorElement()
        ..href = '${Uri.dataFromBytes(bytes, mimeType: 'image/$extension')}'
        ..download =
            'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension'
        ..style.display = 'none'
        ..click();
    } else {
      await FileSaver.instance.saveFile(
        'FlutterLetsDraw-${DateTime.now().toIso8601String()}.$extension',
        bytes,
        extension,
        mimeType: extension == 'png' ? MimeType.PNG : MimeType.JPEG,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:   _appBar,
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: imageFile != null ||webImage != null
                    ? Container(

                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child:
                        Stack(
                          children:<Widget>[
                            (_file.path == "zz")
                                ? Image.asset("assets/pexels2.jpeg")
                                : (kIsWeb)
                                ? Image.memory(webImage)
                                : Image.file(_file),

                            for (int i = 0; i < texts.length; i++)
                              Positioned(
                                left: texts[i].left,
                                top: texts[i].top,
                                child: GestureDetector(
                                  onLongPress: () {
                                    setState(() {
                                      currentIndex = i;
                                      removeText(context);
                                    });
                                  },
                                  onTap: () => setCurrentIndex(context, i),
                                  child: Draggable(
                                    feedback: ImageText(textInfo: texts[i]),
                                    child: ImageText(textInfo: texts[i]),
                                    onDragEnd: (drag) {
                                      final renderBox =
                                      context.findRenderObject() as RenderBox;
                                      Offset off = renderBox.globalToLocal(drag.offset);
                                      setState(() {
                                        texts[i].top = off.dy - 96;
                                        texts[i].left = off.dx;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            creatorText.text.isNotEmpty
                                ? Positioned(
                              left: 0,
                              bottom: 0,
                              child: Text(
                                creatorText.text,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(
                                      0.3,
                                    )),
                              ),
                            )
                                : const Center(
                              child: Text("Add text"),

                            )
                          ]
                        )
                    //Image.file(imageFile!))

                )

               // child: Text("2D editing canvas"),
                  :Center(

                  child:Stack(
                      children: <Widget>[

                       Text("2D editing canvas", style:
                       TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)

                      ]
                  ),
                ) ,


          ),

            Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildIconButton(icon: Icons.add, onpressed: _pickImage),
                      _buildIconButton(icon: Icons.crop, onpressed: _cropImage),
                      _buildIconButton(icon: Icons.clear, onpressed: _clearImage),

                    ],
                  ),
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        hoverColor: Colors.red.shade400,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyApp()),
          );
        },
        child: const Icon(Icons.art_track_outlined)),);

  }

  Widget _buildIconButton(
      {required IconData icon, required void Function()? onpressed}) {
    return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        child: IconButton(
          onPressed: onpressed,
          icon: Icon(icon),
          color: Colors.white,
        ));
  }

  AppBar get _appBar =>
      AppBar

        (

          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                IconButton(
                    icon: Icon(Icons.art_track_outlined, color:Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    }),

                IconButton(
                  icon: const Icon(
                    Icons.text_fields,
                    color: Colors.black,
                  ),
                  onPressed:(){
                    addNewDialog(context);
                  },
                  // () => saveToGallery(context),
                  tooltip: 'Add New Text',
                ),

                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  onPressed: increaseFontSize,
                  tooltip: 'Increase font size',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.black,
                  ),
                  onPressed: decreaseFontSize,
                  tooltip: 'Decrease font size',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.format_align_left,
                    color: Colors.black,
                  ),
                  onPressed: alignLeft,
                  tooltip: 'Align left',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.format_align_center,
                    color: Colors.black,
                  ),
                  onPressed: alignCenter,
                  tooltip: 'Align Center',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.format_align_right,
                    color: Colors.black,
                  ),
                  onPressed: alignRight,
                  tooltip: 'Align Right',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.format_bold,
                    color: Colors.black,
                  ),
                  onPressed: boldText,
                  tooltip: 'Bold',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.format_italic,
                    color: Colors.black,
                  ),
                  onPressed: italicText,
                  tooltip: 'Italic',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.space_bar,
                    color: Colors.black,
                  ),
                  onPressed: addLinesToText,
                  tooltip: 'Add New Line',
                ),
                Tooltip(
                  message: 'Red',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.red),
                      child: const CircleAvatar(
                        backgroundColor: Colors.red,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Tooltip(
                  message: 'White',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.white),
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Tooltip(
                  message: 'Black',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.black),
                      child: const CircleAvatar(
                        backgroundColor: Colors.black,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Tooltip(
                  message: 'Blue',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.blue),
                      child: const CircleAvatar(
                        backgroundColor: Colors.blue,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Tooltip(
                  message: 'Yellow',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.yellow),
                      child: const CircleAvatar(
                        backgroundColor: Colors.yellow,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Tooltip(
                  message: 'Green',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.green),
                      child: const CircleAvatar(
                        backgroundColor: Colors.green,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Tooltip(
                  message: 'Orange',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.orange),
                      child: const CircleAvatar(
                        backgroundColor: Colors.orange,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                Tooltip(
                  message: 'Pink',
                  child: GestureDetector(
                      onTap: () => changeTextColor(Colors.pink),
                      child: const CircleAvatar(
                        backgroundColor: Colors.pink,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                IconButton(
                    icon: Icon(Icons.contact_page, color:Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => home()),
                      );
                    })
              ],
            ),
          ));
  removeText(BuildContext context) {
    setState(() {
      texts.removeAt(currentIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Deleted',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
  setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentIndex = index;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Selected For Styling',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  changeTextColor(Color color) {
    setState(() {
      texts[currentIndex].color = color;
    });
  }

  increaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize += 2;
    });
  }

  decreaseFontSize() {
    setState(() {
      texts[currentIndex].fontSize -= 2;
    });
  }

  alignLeft() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.left;
    });
  }

  alignCenter() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.center;
    });
  }

  alignRight() {
    setState(() {
      texts[currentIndex].textAlign = TextAlign.right;
    });
  }

  boldText() {
    setState(() {
      if (texts[currentIndex].fontWeight == FontWeight.bold) {
        texts[currentIndex].fontWeight = FontWeight.normal;
      } else {
        texts[currentIndex].fontWeight = FontWeight.bold;
      }
    });
  }

  italicText() {
    setState(() {
      if (texts[currentIndex].fontStyle == FontStyle.italic) {
        texts[currentIndex].fontStyle = FontStyle.normal;
      } else {
        texts[currentIndex].fontStyle = FontStyle.italic;
      }
    });
  }

  addLinesToText() {
    setState(() {
      if (texts[currentIndex].text.contains('\n')) {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll('\n', ' ');
      } else {
        texts[currentIndex].text =
            texts[currentIndex].text.replaceAll(' ', '\n');
      }
    });
  }

  addNewText(BuildContext context) {
    setState(() {
      texts.add(
        TextInfo(
          text: textEditingController.text,
          left: 0,
          top: 0,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 20,
          textAlign: TextAlign.left,
        ),
      );
      Navigator.of(context).pop();
    });
  }

  addNewDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Add New Text',
        ),
        content: TextField(
          controller: textEditingController,
          maxLines: 5,
          decoration: const InputDecoration(
            suffixIcon: Icon(
              Icons.edit,
            ),
            filled: true,
            hintText: 'Your Text Here..',
          ),
        ),
        actions: <Widget>[
          DefaultButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back'),
            color: Colors.white,
            textColor: Colors.black,
          ),
          DefaultButton(
            onPressed: () => addNewText(context),
            child: const Text('Add Text'),
            color: Colors.red,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}