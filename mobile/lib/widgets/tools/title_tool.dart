import 'package:flutter/material.dart';

class TitleTool extends StatefulWidget {
  final Function(Map<String, dynamic>) onTitleChanged;

  const TitleTool({super.key, required this.onTitleChanged});

  @override
  State<TitleTool> createState() => _TitleToolState();
}

class _TitleToolState extends State<TitleTool> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  String _titleStyle = 'modern';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Text('Title Generator', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            hintText: 'Enter title',
          ),
          onChanged: (value) => _updateTitle(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _subtitleController,
          decoration: const InputDecoration(
            labelText: 'Subtitle',
            hintText: 'Enter subtitle (optional)',
          ),
          onChanged: (value) => _updateTitle(),
        ),
        
        const SizedBox(height: 24),
        const Text('Title Style', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _StyleOption(label: 'Modern', value: 'modern', selected: _titleStyle == 'modern', onTap: () => _setStyle('modern')),
            _StyleOption(label: 'Classic', value: 'classic', selected: _titleStyle == 'classic', onTap: () => _setStyle('classic')),
            _StyleOption(label: 'Minimal', value: 'minimal', selected: _titleStyle == 'minimal', onTap: () => _setStyle('minimal')),
            _StyleOption(label: 'Bold', value: 'bold', selected: _titleStyle == 'bold', onTap: () => _setStyle('bold')),
          ],
        ),
        
        const SizedBox(height: 24),
        const Text('Preview', style: TextStyle(fontWeight: FontWeight.w500)),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _titleController.text.isEmpty ? 'Your Title' : _titleController.text,
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (_subtitleController.text.isNotEmpty)
                  Text(
                    _subtitleController.text,
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _setStyle(String style) {
    setState(() {
      _titleStyle = style;
      _updateTitle();
    });
  }

  void _updateTitle() {
    widget.onTitleChanged({
      'title': _titleController.text,
      'subtitle': _subtitleController.text,
      'style': _titleStyle,
    });
  }
}

class _StyleOption extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _StyleOption({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}