import 'package:flutter/material.dart';

class LayeringTool extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onLayersChanged;

  const LayeringTool({super.key, required this.onLayersChanged});

  @override
  State<LayeringTool> createState() => _LayeringToolState();
}

class _LayeringToolState extends State<LayeringTool> {
  List<Map<String, dynamic>> _layers = [
    {'id': '1', 'name': 'Background', 'type': 'video', 'visible': true},
    {'id': '2', 'name': 'Overlay', 'type': 'image', 'visible': true},
    {'id': '3', 'name': 'Text', 'type': 'text', 'visible': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Layer Management', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 16),
        
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _layers.length,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex--;
              final item = _layers.removeAt(oldIndex);
              _layers.insert(newIndex, item);
              _updateLayers();
            });
          },
          itemBuilder: (context, index) {
            final layer = _layers[index];
            return Card(
              key: ValueKey(layer['id']),
              child: ListTile(
                leading: Icon(_getLayerIcon(layer['type'])),
                title: Text(layer['name']),
                subtitle: Text(layer['type'].toString().toUpperCase()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(layer['visible'] ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          layer['visible'] = !layer['visible'];
                          _updateLayers();
                        });
                      },
                    ),
                    const Icon(Icons.drag_handle),
                  ],
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Add new layer
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Layer'),
        ),
      ],
    );
  }

  IconData _getLayerIcon(String type) {
    switch (type) {
      case 'video':
        return Icons.videocam;
      case 'image':
        return Icons.image;
      case 'text':
        return Icons.text_fields;
      default:
        return Icons.layers;
    }
  }

  void _updateLayers() {
    widget.onLayersChanged(_layers);
  }
}