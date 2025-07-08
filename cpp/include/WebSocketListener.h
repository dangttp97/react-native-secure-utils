// include/WebSocketListener.h

#pragma once
#include <string>

typedef void (*OnOpenCallback)();
typedef void (*OnMessageCallback)(const char* message);
typedef void (*OnCloseCallback)(int code, const char* reason);
typedef void (*OnErrorCallback)(const char* error);

struct WebSocketListener {
    OnOpenCallback onOpen;
    OnMessageCallback onMessage;
    OnCloseCallback onClose;
    OnErrorCallback onError;
};
