
        console.group('🧹 Clearing all caches...');

        // 2. IndexedDB
        try {
            const dbs = await indexedDB.databases();
            for (const db of dbs.filter(d => d.name?.startsWith('files_v2_'))) {
                if (db.name) {
                    indexedDB.deleteDatabase(db.name);
                    console.log(`✅ IndexedDB deleted: ${db.name}`);
                }
            }
        } catch (e) {
            console.error('❌ IndexedDB error:', e);
        }

        // 3. LocalStorage кэши
        try {
            const keys = Object.keys(localStorage).filter(k =>
                k.includes('cache') || k.includes('settings')
            );
            keys.forEach(k => localStorage.removeItem(k));
            console.log(`✅ LocalStorage cleared: ${keys.length} items`);
        } catch (e) {
            console.error('❌ LocalStorage error:', e);
        }

        console.groupEnd();
        console.log('✅ All caches cleared! Reload the page.');
