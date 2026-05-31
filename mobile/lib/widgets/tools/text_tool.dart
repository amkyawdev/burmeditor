import 'package:flutter/material.dart';

class TextTool extends StatefulWidget {
  final Function(Map<String, dynamic>) onTextChanged;

  const TextTool({super.key, required this.onTextChanged});

  @override
  State<TextTool> createState() => _TextToolState();
}

class _TextToolState extends State<TextTool> {
  final TextEditingController _textController = TextEditingController();
  double _fontSize = 24;
  Color _textColor = Colors.white;
  String _fontFamily = 'Roboto';
  TextAlign _textAlign = TextAlign.center;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Text Overlay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        
        TextField(
          controller: _textController,
          decoration: const InputDecoration(
            labelText: 'Text Content',
            hintText: 'Enter your text here',
          ),
          maxLines: 3,
          onChanged: (value) => _updateText(),
        ),
        
        const SizedBox(height: 24),
        const Text('Font Size', style: TextStyle(fontWeight: FontWeight.w500)),
        Slider(
          value: _fontSize,
          min: 12,
          max: 72,
          divisions: 60,
          label: '${_fontSize.toInt()}px',
          onChanged: (value) => setState(() {
            _fontSize = value;
            _updateText();
          }),
        ),
        
        const SizedBox(height: 16),
        const Text('Font Family', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['Roboto', 'Pyidaungsu', 'Poppins'].map((font) {
            return ChoiceChip(
              label: Text(font),
              selected: _fontFamily == font,
              onSelected: (selected) {
                if (selected) setState(() {
                  _fontFamily = font;
                  _updateText();
                });
              },
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        const Text('Text Color', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [Colors.white, Colors.black, Colors.red, Colors.blue, Colors.green, Colors.yellow].map((color) {
            return GestureDetector(
              onTap: () => setState(() {
                _textColor = color;
                _updateText();
              }),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: _textColor == color ? Theme.of(context).primaryColor : Colors.grey,
                    width: _textColor == color ? 3 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
        const Text('Alignment', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        SegmentedButton<TextAlign>(
          segments: const [
            ButtonSegment(value: TextAlign.left, icon: Icon(Icons.format_align_left)),
            ButtonSegment(value: TextAlign.center, icon: Icon(Icons.format_align_center)),
            ButtonSegment(value: TextAlign.right, icon: Icon(Icons.format_align_right)),
          ],
          selected: {_textAlign},
          onSelectionChanged: (selection) => setState(() {
            _textAlign = selection.first;
            _updateText();
          }),
        ),
      ],
    );
  }

  void _updateText() {
    widget.onTextChanged({
      'text': _textController.text,
      'fontSize': _fontSize,
      'color': _textColor,
      'fontFamily': _fontFamily,
      'textAlign': _textAlign,
    });
  }
}