import configparser
import os
import time
import pyttsx3
from slpp import slpp as lua
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class TTSManager:
    def __init__(self):
        try:
            self.engine = pyttsx3.init()
        except (RuntimeError, ValueError) as e:
            print("Error initializing text-to-speech engine.")
            print("Your system may be missing a text-to-speech driver, or it may be misconfigured.")
            print(f"Error details: {e}")
            self.engine = None

    def speak(self, text, voice=None, rate=None, volume=None):
        if not self.engine:
            # Silently fail if the engine didn't initialize.
            # The user has already been warned.
            return

        if voice and voice != "Default":
            self.engine.setProperty('voice', voice)
        if rate:
            # The default rate is 200, so we'll scale it.
            self.engine.setProperty('rate', 200 * rate)
        if volume:
            self.engine.setProperty('volume', volume)

        self.engine.say(text)
        self.engine.runAndWait()

def find_saved_variables_file(wow_path):
    """
    Finds the QuestNarrator.lua file in the WoW directory.
    Since the account name is variable, we search for it.
    """
    wtf_path = os.path.join(wow_path, "WTF", "Account")
    if not os.path.exists(wtf_path):
        return None

    for account_name in os.listdir(wtf_path):
        account_path = os.path.join(wtf_path, account_name)
        if os.path.isdir(account_path) and account_name != "SavedVariables":
            saved_vars_path = os.path.join(account_path, "SavedVariables", "QuestNarrator.lua")
            if os.path.exists(saved_vars_path):
                return saved_vars_path
    return None

def extract_lua_table(content, table_name):
    """
    Extracts a specific Lua table from a string containing multiple Lua assignments.
    """
    try:
        start = content.find(f"{table_name} =")
        if start == -1:
            return None

        start_brace = content.find('{', start)
        if start_brace == -1:
            return None

        open_braces = 1
        i = start_brace + 1
        while i < len(content) and open_braces > 0:
            if content[i] == '{':
                open_braces += 1
            elif content[i] == '}':
                open_braces -= 1
            i += 1

        if open_braces == 0:
            return content[start_brace:i]
        else:
            return None
    except Exception as e:
        print(f"Error extracting table {table_name}: {e}")
        return None

class QuestFileHandler(FileSystemEventHandler):
    def __init__(self, filepath, tts_manager):
        self.filepath = filepath
        self.tts_manager = tts_manager
        self.last_timestamp = 0
        print("Processing file on startup...")
        self.process_file()

    def on_modified(self, event):
        if event.src_path == self.filepath:
            # Add a small delay to ensure the file is fully written
            time.sleep(0.1)
            print("File modified, processing...")
            self.process_file()

    def process_file(self):
        try:
            with open(self.filepath, 'r', encoding='utf-8') as f:
                content = f.read()
        except (FileNotFoundError, IOError):
            return

        comm_table_str = extract_lua_table(content, "QuestNarratorComm")
        db_table_str = extract_lua_table(content, "QuestNarratorDB")

        if not comm_table_str or not db_table_str:
            return

        try:
            comm_data = lua.decode(comm_table_str)
            db_data = lua.decode(db_table_str)

            text = comm_data.get('text')
            timestamp = comm_data.get('timestamp')

            if text and timestamp and timestamp > self.last_timestamp:
                profile = db_data.get('profile', {})
                if profile.get('enabled', False):
                    print(f"New quest text: {text}")
                    self.tts_manager.speak(
                        text,
                        voice=profile.get('voice'),
                        rate=profile.get('rate'),
                        volume=profile.get('volume')
                    )
                self.last_timestamp = timestamp
        except Exception:
            # Ignore errors from reading partially written files
            pass

def main():
    # Get the absolute path to the directory where the script is located
    script_dir = os.path.dirname(os.path.abspath(__file__))
    config_path = os.path.join(script_dir, 'config.ini')

    config = configparser.ConfigParser()
    if not os.path.exists(config_path):
        print(f"Error: {config_path} not found. Please create it.")
        return

    config.read(config_path)
    wow_path = config['WOW'].get('PATH')

    if not wow_path or not os.path.exists(wow_path):
        print("WoW path not configured or invalid. Please set it in config.ini")
        return

    sv_file = find_saved_variables_file(wow_path)

    if not sv_file:
        print("Could not find QuestNarrator.lua SavedVariables file.")
        print("Please run World of Warcraft with the addon enabled at least once.")
        return

    print(f"Found SavedVariables file: {sv_file}")

    tts_manager = TTSManager()

    print("Starting file watcher. Press Ctrl+C to stop.")

    event_handler = QuestFileHandler(sv_file, tts_manager)
    observer = Observer()
    observer.schedule(event_handler, os.path.dirname(sv_file), recursive=False)
    observer.start()

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
    print("File watcher stopped.")

if __name__ == "__main__":
    main()