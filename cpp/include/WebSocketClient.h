#pragma once
#include <string>
#include "WebSocketListener.h"

class WebSocketClient {
public:
    WebSocketClient(const std::string& url, const std::string& pubkeyBase64);

    void connect();
    void send(const std::string& message);
    void close();

    void setListener(WebSocketListener* listener);

private:
    std::string url;
    std::string pinnedPubKey;
    WebSocketListener* listener = nullptr;

    void emitOpen();
    void emitMessage(const std::string& msg);
    void emitClose(int code, const std::string& reason);
    void emitError(const std::string& error);
};

