# QuestNarrator TTS

This application is the text-to-speech (TTS) engine for the QuestNarrator World of Warcraft addon. It monitors the addon's data file for new quest text and reads it aloud using a system-installed TTS voice.

## Requirements

*   Python 3.6+
*   The QuestNarrator WoW addon installed and enabled.

## Installation

1.  **Install Python:** If you don't have Python installed, download and install it from [python.org](https://www.python.org/downloads/). Make sure to check the box that says "Add Python to PATH" during installation.

2.  **Install Dependencies:** Open a command prompt or terminal, navigate to this `QuestNarrator_TTS` directory, and run the following command to install the required Python libraries:
    ```
    pip install -r requirements.txt
    ```

## Configuration

1.  **Find your WoW Path:** Locate the `_retail_` directory of your World of Warcraft installation.
    *   Example (Windows): `C:\Program Files (x86)\World of Warcraft\_retail_`
    *   Example (macOS): `/Applications/World of Warcraft/_retail_`

2.  **Edit `config.ini`:** Open the `config.ini` file in a text editor and paste your WoW path into the `PATH` field.

    ```ini
    [WOW]
    PATH = C:\Program Files (x86)\World of Warcraft\_retail_
    ```

## Running the Application

To start the TTS engine, simply run the `main.py` script from your command prompt or terminal while inside the `QuestNarrator_TTS` directory:

```
python main.py
```

The application will start watching for quest text from the addon. You can now launch World of Warcraft. As you accept and progress through quests, the text will be read aloud.

**Important:** You must leave this application running in the background while you play World of Warcraft to hear the quest narration.