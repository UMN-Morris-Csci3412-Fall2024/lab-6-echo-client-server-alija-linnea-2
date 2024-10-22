#!/usr/bin/env bats

setup() {
  BATS_TMPDIR=$(mktemp --directory)
  cd ../src || exit 1
  rm -f echoserver/*.class
  javac -d ../bin echoserver/EchoServer.java
  java -cp ../bin echoserver.EchoServer &
  sleep 1  # Allow the server to start up
  cd ../test || exit 1
}

teardown() {
  rm -rf "$BATS_TMPDIR"
  kill %1
  sleep 1  # Ensure the server shuts down completely
}


@test "Your server code compiles" {
  cd /Users/alijawosti/lab-6-echo-client-server-alija-linnea-2/src
  rm -f echoserver/EchoServer.class
  run javac -d ../bin echoserver/EchoServer.java
  cd ../test
  [ "$status" -eq 0 ]
}

@test "Your server starts successfully" {
  cd /Users/alijawosti/lab-6-echo-client-server-alija-linnea-2/bin
  java echoserver.EchoServer &
  status=$?
  kill %1
  cd ../test
  [ "$status" -eq 0 ]
}

@test "Your server handles a small bit of text" {
  cd /Users/alijawosti/lab-6-echo-client-server-alija-linnea-2/bin
  java echoserver.EchoServer &
  sleep 1  # Allow server to start
  java echoserver.EchoClient < ../test/etc/textTest.txt > "$BATS_TMPDIR"/textTest.txt
  run diff ../test/etc/textTest.txt "$BATS_TMPDIR"/textTest.txt
  kill %1
  cd ../test
  [ "$status" -eq 0 ]
}

@test "Your server handles a large chunk of text" {
  cd /Users/alijawosti/lab-6-echo-client-server-alija-linnea-2/bin
  java echoserver.EchoServer &
  sleep 1  # Allow server to start
  java echoserver.EchoClient < ../test/etc/words.txt > "$BATS_TMPDIR"/words.txt
  run diff ../test/etc/words.txt "$BATS_TMPDIR"/words.txt
  kill %1
  cd ../test
  [ "$status" -eq 0 ]
}

@test "Your server handles binary content" {
  cd /Users/alijawosti/lab-6-echo-client-server-alija-linnea-2/bin
  java echoserver.EchoServer &
  sleep 1  # Allow server to start
  java echoserver.EchoClient < ../test/etc/pumpkins.jpg > "$BATS_TMPDIR"/pumpkins.jpg
  run diff ../test/etc/pumpkins.jpg "$BATS_TMPDIR"/pumpkins.jpg
  kill %1
  cd ../test
  [ "$status" -eq 0 ]
}
