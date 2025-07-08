#include "WebSocketClient.h"
#include <iostream>
#include <openssl/x509.h>
#include <openssl/pem.h>
#include <openssl/sha.h>
#include <openssl/bio.h>
#include <openssl/buffer.h>

// Dummy logic cho demo
WebSocketClient::WebSocketClient(const std::string& url, const std::string& pubkeyBase64)
    : url(url), pinnedPubKey(pubkeyBase64) {}

void WebSocketClient::connect() {
    std::cout << "Connecting to: " << url << std::endl;
    std::cout << "Pinning with: " << pinnedPubKey << std::endl;
}

void WebSocketClient::send(const std::string& msg) {
    std::cout << "Sending: " << msg << std::endl;
}

void WebSocketClient::close() {
    std::cout << "Closing connection" << std::endl;
}

void WebSocketClient::setListener(WebSocketListener* l) {
    listener = l;
}

void WebSocketClient::emitOpen() {
    if (listener && listener->onOpen) {
        listener->onOpen();
    }
}

void WebSocketClient::emitMessage(const std::string& msg) {
    if (listener && listener->onMessage) {
        listener->onMessage(msg.c_str());
    }
}

void WebSocketClient::emitClose(int code, const std::string& reason) {
    if (listener && listener->onClose) {
        listener->onClose(code, reason.c_str());
    }
}

void WebSocketClient::emitError(const std::string& error) {
    if (listener && listener->onError) {
        listener->onError(error.c_str());
    }
}


extern "C" {
    WebSocketClient* ws_create(const char* url, const char* pubkey) {
        return new WebSocketClient(url, pubkey);
    }

    void ws_connect(WebSocketClient* client) {
        client->connect();
    }

    void ws_send(WebSocketClient* client, const char* msg) {
        client->send(msg);
    }

    void ws_close(WebSocketClient* client) {
        client->close();
    }

    void ws_destroy(WebSocketClient* client) {
        delete client;
    }
}
