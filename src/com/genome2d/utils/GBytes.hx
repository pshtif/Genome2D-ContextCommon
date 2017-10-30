package com.genome2d.utils;

import com.genome2d.macros.MGDebug;
import haxe.io.Bytes;
import haxe.io.FPHelper;

@:access(haxe.io.Bytes)
class GBytes {

    public var position:Int;

    private var g2d_length:Int;
    private var g2d_data:Bytes;

    public function new(p_bytes:Bytes) {
        position = 0;
        g2d_data = p_bytes;
        g2d_length = p_bytes.length;
    }

    public function getBytesAvailable():UInt {
        return g2d_length - position;
    }

    // READ

    public function readBoolean():Bool {
        if (position < g2d_length) {
            return (g2d_data.get(position++) != 0);
        } else {

            MGDebug.ERROR("EOF");
            return false;
        }
    }

    public function readByte():Int {
        var value = readUnsignedByte();

        if (value & 0x80 != 0) {
            return value - 0x100;
        } else {
            return value;
        }
    }

    public function readDouble():Float {

        var ch1 = readInt();
        var ch2 = readInt();

        // Little endian
        // return FPHelper.i64ToDouble (ch1, ch2);

        // Big endian
        return FPHelper.i64ToDouble(ch2, ch1);
    }


    public function readFloat():Float {

        return FPHelper.i32ToFloat(readInt ());
    }


    public function readInt():Int {
        var ch1 = readUnsignedByte();
        var ch2 = readUnsignedByte();
        var ch3 = readUnsignedByte();
        var ch4 = readUnsignedByte();

        // Little endian
        //return (ch4 << 24) | (ch3 << 16) | (ch2 << 8) | ch1;

        // Big endian
        return (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
    }


    public function readMultiByte(p_length:Int):String {
        return readUTFBytes(p_length);
    }


    public function readShort():Int {
        var ch1 = readUnsignedByte();
        var ch2 = readUnsignedByte();

        var value;

        // Little endian
        //value = ((ch2 << 8) | ch1);

        // Big endian
        value = ((ch1 << 8) | ch2);

        if ((value & 0x8000) != 0) {
            return value - 0x10000;
        } else {
            return value;
        }
    }


    public function readUnsignedByte():Int {

        if (position < g2d_length) {
            return g2d_data.get(position++);
        } else {
            MGDebug.ERROR("EOF");
            return 0;
        }
    }


    public function readUnsignedInt():Int {

        var ch1 = readUnsignedByte();
        var ch2 = readUnsignedByte();
        var ch3 = readUnsignedByte();
        var ch4 = readUnsignedByte();

        // Little endian
        //return (ch4 << 24) | (ch3 << 16) | (ch2 << 8) | ch1;

        // Big endian
        return (ch1 << 24) | (ch2 << 16) | (ch3 << 8) | ch4;
    }


    public function readUnsignedShort():Int {
        var ch1 = readUnsignedByte();
        var ch2 = readUnsignedByte();

        // Little endian
        //return (ch2 << 8) + ch1;

        // Big endian
        return (ch1 << 8) | ch2;
    }


    public function readUTF():String {
        var bytesCount = readUnsignedShort();
        return readUTFBytes(bytesCount);
    }


    public function readUTFBytes(p_length:Int):String {
        if (position + p_length > g2d_data.length) {
            MGDebug.ERROR("EOF");
        }

        position += p_length;

        return g2d_data.getString(position - p_length, p_length);
    }

    // WRITE

    private inline function g2d_setData(p_bytes:Bytes):Void {
        g2d_data.b = p_bytes.b;
        g2d_length = p_bytes.length;
    }

    private function g2d_resize(p_size:Int) {

        if (p_size > g2d_length) {
            var bytes = Bytes.alloc(((p_size + 1) * 3) >> 1);
            var cacheLength = g2d_length;
            bytes.blit(0, g2d_data, 0, g2d_length);
            g2d_length = bytes.length;
            g2d_setData(bytes);

        }

        if (g2d_length < p_size) {
            g2d_data.length = g2d_length = p_size;
        }
    }

    public function writeBoolean(p_value:Bool):Void {

        this.writeByte(p_value ? 1 : 0);

    }

    public function writeByte(p_value:Int):Void {

        g2d_resize(position + 1);
        g2d_data.set(position++, p_value & 0xFF);
    }

    public function writeBytes(p_bytes:Bytes, p_offset:UInt = 0, p_length:UInt = 0):Void {

        if (p_bytes.length == 0) return;
        if (p_length == 0) p_length = p_bytes.length - p_offset;

        g2d_resize(position + p_length);
        g2d_data.blit(position, p_bytes, p_offset, p_length);

        position += p_length;

    }

    public function writeDouble(p_value:Float):Void {

        var int64 = FPHelper.doubleToI64(p_value);

        // Little endian
        //writeInt (int64.low);
        //writeInt (int64.high);

        // Big endian
        writeInt(int64.high);
        writeInt(int64.low);
    }


    public function writeFloat(p_value:Float):Void {

        // Little endian
        //__resize (position + 4);
        //setFloat (position, value);
        //position += 4;

        // Big endian
        var int = FPHelper.floatToI32(p_value);
        writeInt(int);
    }


    public function writeInt(p_value:Int):Void {

        g2d_resize(position + 4);

        // Little endian
        //g2d_data.set (position++, value & 0xFF);
        //g2d_data.set (position++, (value >> 8) & 0xFF);
        //g2d_data.set (position++, (value >> 16) & 0xFF);
        //g2d_data.set (position++, (value >> 24) & 0xFF);

        // Big endian
        g2d_data.set(position++, (p_value >> 24) & 0xFF);
        g2d_data.set(position++, (p_value >> 16) & 0xFF);
        g2d_data.set(position++, (p_value >> 8) & 0xFF);
        g2d_data.set(position++, p_value & 0xFF);
    }


    public function writeMultiByte(p_value:String):Void {

        writeUTFBytes(p_value);
    }


    public function writeShort(p_value:Int):Void {

        g2d_resize(position + 2);

        // Little endian
        //g2d_data.set(position++, value);
        //g2d_data.set(position++, value >> 8);

        // Big endian
        g2d_data.set(position++, p_value >> 8);
        g2d_data.set(position++, p_value);
    }


    public function writeUnsignedInt(p_value:Int):Void {
        writeInt(p_value);
    }


    public function writeUTF(p_value:String):Void {

        var bytes = Bytes.ofString(p_value);

        writeShort(bytes.length);
        writeBytes(bytes);
    }


    public function writeUTFBytes(p_value:String):Void {

        var bytes = Bytes.ofString(p_value);
        writeBytes(Bytes.ofString(p_value));
    }
}
