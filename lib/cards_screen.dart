import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'person_data.dart'; // Import shared data model

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => CardsScreenState();
}

class CardsScreenState extends State<CardsScreen> {
  List<PersonData> _allMembers = [];

  void updateData(PersonData head, List<PersonData> members) {
    setState(() {
      _allMembers = [head, ...members];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: _allMembers.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card_off, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            const Text(
              "No cards generated yet\nನಮೂನೆಗಳನ್ನು ಇನ್ನೂ ರಚಿಸಲಾಗಿಲ್ಲ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            const Text(
              "Fill the form first to generate cards\nಕಾರ್ಡ್‌ಗಳನ್ನು ರಚಿಸಲು ಮೊದಲು ಫಾರ್ಮ್ ಭರ್ತಿ ಮಾಡಿ",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _allMembers.length,
        itemBuilder: (context, index) {
          return GeneratedIdCard(data: _allMembers[index]);
        },
      ),
    );
  }
}

// --- Generated ID Card Widget ---
class GeneratedIdCard extends StatefulWidget {
  final PersonData data;
  const GeneratedIdCard({super.key, required this.data});

  @override
  State<GeneratedIdCard> createState() => _GeneratedIdCardState();
}

class _GeneratedIdCardState extends State<GeneratedIdCard> {
  final GlobalKey _globalKey = GlobalKey();
  bool _isSaving = false;

  Future<void> _saveCardToGallery() async {
    setState(() => _isSaving = true);
    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        await Gal.requestAccess();
      }

      RenderRepaintBoundary boundary =
      _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        await Gal.putImageBytes(pngBytes);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Card Saved to Gallery!"), backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      margin: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          RepaintBoundary(
            key: _globalKey,
            child: Container(
              height: 210,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
                ],
                image: const DecorationImage(
                  image: AssetImage('assets/app_icon.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.15,
                  colorFilter: ColorFilter.mode(Colors.grey, BlendMode.saturation),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withOpacity(0.6),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.teal.shade700,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              image: widget.data.profileImage != null
                                  ? DecorationImage(image: FileImage(widget.data.profileImage!), fit: BoxFit.cover)
                                  : null,
                            ),
                            child: widget.data.profileImage == null
                                ? const Icon(Icons.person, size: 40, color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              widget.data.relationship.split('/').first.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              widget.data.age.isNotEmpty ? "${widget.data.age} Yrs" : "N/A",
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.data.name.toUpperCase(),
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                            const Divider(),
                            _cardRow(Icons.work, widget.data.occupation),
                            _cardRow(Icons.phone, widget.data.mobile),
                            _cardRow(Icons.fingerprint, widget.data.aadhar),
                            _cardRow(Icons.location_on, widget.data.district ?? "Unknown"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: InkWell(
              onTap: _saveCardToGallery,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)]
                ),
                child: _isSaving
                    ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                )
                    : const Icon(Icons.download, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.black87),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text.isEmpty ? "Not Provided" : text,
              style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}