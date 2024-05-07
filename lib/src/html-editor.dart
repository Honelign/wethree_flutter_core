// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
// import 'package:delta_markdown/delta_markdown.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:markdown/markdown.dart';
// import 'package:html2md/html2md.dart' as html2md;

// class HtmlEditor extends StatefulWidget {
//   HtmlEditor({Key key, this.text, @required this.value, this.height})
//       : super(key: key);
//   final String text;
//   final ValueChanged<String> value;
//   final int height;

//   @override
//   _HtmlEditorState createState() => _HtmlEditorState();
// }

// class _HtmlEditorState extends State<HtmlEditor> {
//   quill.QuillController _controller;
//   final FocusNode editorFocusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();

//     _controller = quill.QuillController(
//         document: widget.text != null && widget.text.isNotEmpty
//             ? htmlToDocument(widget.text)
//             : quill.Document(),
//         selection: TextSelection.collapsed(offset: 0));

//     //keyboard triggering by default, so this is a workaround to hide it on init.
//     Future.delayed(Duration(milliseconds: 0), () {
//       FocusScope.of(context).unfocus();
//     });

//     //listen input changes and update to parent widget
//     _controller.addListener(() {
//       widget.value(quillDeltaToHtml(_controller.document.toDelta()));
//     });
//   }

//   String quillDeltaToHtml(Delta delta) {
//     final convertedValue = jsonEncode(delta.toJson());
//     final markdown = deltaToMarkdown(convertedValue);
//     final html = markdownToHtml(markdown);

//     return html;
//   }

//   quill.Document htmlToDocument(String html) {
//     var markdown = html2md.convert(html);
//     final delta = jsonDecode(markdownToDelta(markdown));
//     return quill.Document.fromDelta(quill.Delta.fromJson(delta));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             quill.QuillToolbar.basic(
//               showBackgroundColorButton: false,
//               showHeaderStyle: false,
//               showListBullets: false,
//               showListNumbers: false,
//               showColorButton: false,
//               showLink: false,
//               showCodeBlock: false,
//               showIndent: false,
//               showStrikeThrough: false,
//               showUnderLineButton: false,
//               showListCheck: false,
//               showQuote: false,
//               controller: _controller,
//             ),
//             Container(
//               constraints:
//                   BoxConstraints(minHeight: widget.height?.toDouble() ?? 200),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: quill.QuillEditor(
//                     padding: EdgeInsets.all(5),
//                     autoFocus: true,
//                     controller: _controller,
//                     readOnly: false,
//                     expands: false,
//                     scrollable: true,
//                     focusNode: editorFocusNode,
//                     scrollController: ScrollController()),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
