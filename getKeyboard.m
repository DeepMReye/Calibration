function logs = getKeyboard(logs)
% set up key board and start monitoring button presses
% MN, September 2021

KbName('UnifyKeyNames')
logs{1}.keys.keyBoardInds      = GetKeyboardIndices;
logs{1}.keys.escapeKey         = KbName('ESCAPE'); % quit
logs{1}.keys.upKey             = KbName('UpArrow');
logs{1}.keys.downKey           = KbName('DownArrow');
logs{1}.keys.leftKey           = KbName('LeftArrow');
logs{1}.keys.rightKey          = KbName('RightArrow');
logs{1}.keys.scannerTriggerKey = KbName('s'); % scanner trigger
logs{1}.keys.spaceKey          = KbName('Space'); % enter
logs{1}.keys.response_right    = KbName('c');
logs{1}.keys.response_left     = KbName('b');
KbQueueCreate(max(logs{1}.keys.keyBoardInds));
KbQueueStart();
end