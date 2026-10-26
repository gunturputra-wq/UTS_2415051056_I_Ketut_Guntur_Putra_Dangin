import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/reading_note.dart';

class ReadingNoteService {
  ReadingNoteService({SupabaseClient? client})
      : _providedClient = client;

  final SupabaseClient? _providedClient;

  SupabaseClient get _client =>
      _providedClient ?? Supabase.instance.client;

  static const String _table = 'reading_notes';

  Future<List<ReadingNote>> getReadingNotes() async {
    final response = await _client
        .from(_table)
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map(
          (item) => ReadingNote.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<ReadingNote> addReadingNote(ReadingNote note) async {
    final response = await _client
        .from(_table)
        .insert(note.toInsertJson())
        .select()
        .single();

    return ReadingNote.fromJson(response);
  }

  Future<ReadingNote> updateReadingNote(ReadingNote note) async {
    final id = note.id;

    if (id == null) {
      throw ArgumentError(
        'ID catatan diperlukan untuk memperbarui data.',
      );
    }

    final response = await _client
        .from(_table)
        .update(note.toUpdateJson())
        .eq('id', id)
        .select()
        .single();

    return ReadingNote.fromJson(response);
  }

  Future<void> deleteReadingNote(int id) async {
    await _client.from(_table).delete().eq('id', id);
  }
}
