#
# JupyterZMQ: UUID function
#

#! @Description
#!   Create a new zero UUID
InstallGlobalFunction(NewUUID,
    function()
        local uuid;
        uuid := rec( bits := BlistList([1..128], []));
        return Objectify(UUIDType, uuid);
    end);

#! @Description
#!   Generate a random UUID according to RFC4122
InstallGlobalFunction(
    RandomUUID,
    function()
        local puuid, uuid;

        puuid := HexStringInt(Random(0,2^128-1));
        if Length(puuid) < 32 then
            puuid := Concatenation(RepeatedString(" ", 32 - Length(puuid)), puuid);
        fi;
        uuid := BlistStringDecode(puuid);
        # Set version to 4
        uuid{[49..52]} := [false, true, false, false];
        # Set variant to RFC4122
        uuid{[70..72]} := [true, false, false];

        return Objectify( UUIDType, rec( bits := uuid ) );
    end);

InstallGlobalFunction(
    StringUUID,
    function(uuid)
        local hex;
        hex := LowercaseString(HexStringBlist(uuid));
        return JoinStringsWithSeparator([
                    hex{[1..8]}, hex{[9..12]}, hex{[13..16]},
                    hex{[17..20]}, hex{[20..32]}],
                    "-");
    end);

InstallMethod(ViewObj, "for UUID", [IsUUID and IsUUIDBlistRep],
   function(uuid)
        Print("<uuid ");
        Print(String(uuid));
        Print(">");
   end);

InstallMethod(String, "for UUID", [IsUUID and IsUUIDBlistRep],
    function(uuid)
        return StringUUID(uuid!.bits);
    end);

