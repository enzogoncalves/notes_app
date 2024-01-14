abstract class NoteState {}

class NoteInitialState extends NoteState {}

class NoteCreateInProgessState extends NoteState {}

class NoteCreatedState extends NoteState {}

class NoteCreateErrorState extends NoteState {}

class NoteEditedState extends NoteState {}

class NoteEditInProgressState extends NoteState {}

class NoteDeletedState extends NoteState {}
