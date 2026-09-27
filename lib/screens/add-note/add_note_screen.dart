import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/note.dart';
import 'package:flutter_application_2/repository/notes_repository.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;
  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  
  String _selectedTime = '12:00';

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked.format(context);
      });
    }
  }
  // ----------------------------------------------------

  @override
  void initState() {
    if (widget.note != null) {
      _title.text = widget.note!.title;
      _description.text = widget.note!.description;
      _selectedTime = widget.note!.time;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        actions: [
          widget.note != null ? IconButton(
                onPressed: () {
                  showDialog(context: context, builder: (context) => AlertDialog(
                    content: const Text('ลบจริงหรือไม่?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('ไม่'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteNote();
                        },
                        child: const Text('ลบ'),
                      ),
                    ],
                  ));
                },
                icon: const Icon(Icons.delete_outline),
              ): const SizedBox(),
          IconButton(
            onPressed: widget.note == null ? _insertNote : _updateNote,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: InputDecoration(
                hintText: 'กรอกหัวข้องานที่นี่',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),
          
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'เวลาที่ต้องทำ: $_selectedTime',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            // ------------------------------------------

            const SizedBox(height: 15),
            Expanded(
              child: TextField(
                controller: _description,
                decoration: InputDecoration(
                  hintText: 'กรอกเนื้อหางานที่นี่',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 50,
              ),
            ),
        ],),
      )
    );
  }

  Future<void> _insertNote() async {
      final note = Note(
        title: _title.text,
        description: _description.text,
        createdAt: DateTime.now(),
        time: _selectedTime,
      );
      await NotesRepository.insert(note: note);
      if (mounted) Navigator.pop(context);
  }

  Future<void> _updateNote() async {
      final note = Note(
        id: widget.note!.id!,
        title: _title.text,
        description: _description.text,
        createdAt: widget.note!.createdAt,
        time: _selectedTime,
      );
      await NotesRepository.update(note: note);
      if (mounted) Navigator.pop(context);
  }

  Future<void> _deleteNote() async {
    NotesRepository.delete(note: widget.note!).then((e){
      if (mounted) Navigator.pop(context);
    });
  }
}