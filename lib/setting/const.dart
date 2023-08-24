const String DATABASE_NAME = 'offline_first.db';

const String CREATE_NOTI_TABLE = '''
        create table notificaciones (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          senderId TEXT,
          category TEXT,
          collapseKey TEXT,
          contentAvailable TEXT,
          data TEXT,
          fromD TEXT,
          messageId TEXT,
          messageType TEXT,
          mutableContent TEXT,
          title TEXT,
          body TEXT,
          sentTime TEXT,
          threadId TEXT,
          ttl TEXT,
          seen TEXT
        )
    ''';
