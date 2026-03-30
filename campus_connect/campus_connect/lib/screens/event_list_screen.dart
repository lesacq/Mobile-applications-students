import '../main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/event_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'add_event_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'comment_screen.dart';
import 'edit_event_screen.dart';
import 'chat_screen.dart';


class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}


class _EventListScreenState extends State<EventListScreen> {
      void _openChat(BuildContext context) {
        final user = Provider.of<AuthViewModel>(context, listen: false).user;
        if (user != null && user.email != null) {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => ChatScreen(roomId: 'institutional_chat'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please sign in to access chat.')),
          );
        }
      }
    String _searchQuery = '';
    DateTime? _searchDate;
  @override
  void initState() {
    super.initState();
    Provider.of<EventViewModel>(context, listen: false).listenToEvents();
  }


  @override
  Widget build(BuildContext context) {
    final eventVm = Provider.of<EventViewModel>(context);
    final userId = Provider.of<AuthViewModel>(context, listen: false).user?.uid ?? '';


    final filteredEvents = eventVm.events.where((event) {
      final matchesTitle = event.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDate = _searchDate == null ||
        (event.date.year == _searchDate!.year && event.date.month == _searchDate!.month && event.date.day == _searchDate!.day);
      return matchesTitle && matchesDate;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () => _openChat(context),
            tooltip: 'Institution Chat',
          ),
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
            tooltip: 'Toggle Dark Mode',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by title...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.calendar_today),
                        label: Text(_searchDate == null ? 'Filter by date' : _formatDate(_searchDate!)),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _searchDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          setState(() => _searchDate = picked);
                        },
                      ),
                    ),
                    if (_searchDate != null)
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => setState(() => _searchDate = null),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: eventVm.isLoading
          ? Center(child: CircularProgressIndicator())
          : eventVm.errorMessage != null
              ? Center(child: Text(eventVm.errorMessage!))
              : ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(event.title),
                        subtitle: Text('${event.description}\n${_formatDate(event.date)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                event.likes.contains(userId) ? Icons.favorite : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () => eventVm.toggleLike(event.id, userId),
                            ),
                            Text('${event.likes.length}'),
                            IconButton(
                              icon: Icon(Icons.comment),
                              onPressed: () => Navigator.push(context, MaterialPageRoute(
                                builder: (_) => CommentScreen(event: event)
                              )),
                            ),
                            IconButton(
                              icon: Icon(Icons.share, color: Colors.green),
                              onPressed: () {
                                final shareText = 'Check out this event: ${event.title}\n${event.description}\nDate: ${_formatDate(event.date)}';
                                Share.share(shareText);
                              },
                            ),
                            if (event.createdBy == userId) ...[
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditEventScreen(event: event),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.grey),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Event'),
                                      content: Text('Are you sure you want to delete this event?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, false),
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await Provider.of<EventViewModel>(context, listen: false).deleteEvent(event.id);
                                  }
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddEventScreen())),
        child: Icon(Icons.add),
      ),
    );
  }


  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
