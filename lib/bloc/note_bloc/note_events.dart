import 'package:notes_app/models/note_model.dart';

abstract class NoteEvent {}

class NoteReturnToInitialStateEvent extends NoteEvent {}

class NoteCreatedEvent extends NoteEvent {
  NoteCreatedEvent({required this.title, required this.text});

  String title;
  String text;
}

class NoteEditEvent extends NoteEvent {
  NoteEditEvent({required this.note});

  Note note;
}

class NoteEditingInProgressEvent extends NoteEvent {}

class NoteDeleteEvent extends NoteEvent {
  NoteDeleteEvent({required this.note});

  Note note;
}
