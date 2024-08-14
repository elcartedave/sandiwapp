import 'package:flutter/material.dart';
import 'package:linkable/linkable.dart';
import 'package:sandiwapp/components/dateformatter.dart'; // Ensure you have the linkable package installed

class ChatBubble extends StatefulWidget {
  final String message;
  final DateTime date; // Add a date attribute to show
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.date,
    required this.isCurrentUser,
  });

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool _isDateVisible = false; // State variable to track visibility

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.isCurrentUser
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isDateVisible = !_isDateVisible; // Toggle visibility
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: widget.isCurrentUser ? Colors.black : Colors.grey.shade300,
            ),
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              widget.message,
              style: TextStyle(
                  color: widget.isCurrentUser ? Colors.white : Colors.black),
            ),
          ),
        ),
        if (_isDateVisible) // Show date and time if _isDateVisible is true
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
            child: Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              shortDateFormatter(widget.date), // Format the date and time
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }

  // Method to format the date and time
  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year} ${date.hour}:${date.minute}";
  }
}
