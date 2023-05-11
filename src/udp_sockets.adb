with Ada.Text_IO;
with Ada.Unchecked_Conversion;

package body udp_sockets is
   
   procedure init(Self : in out udp_sockets_type) is
      Server_Addr : GNAT.Sockets.Sock_Addr_Type;
   begin
      GNAT.Sockets.Initialize;
      Self.Address.Addr := GNAT.Sockets.Inet_Addr("127.0.0.1");
      Self.Address.Port := 60001;
      
      Server_Addr.Addr := Self.Address.Addr;
      Server_Addr.Port := 60002;
      
      GNAT.Sockets.Create_Socket(Self.Client, GNAT.Sockets.Family_Inet, GNAT.Sockets.Socket_Datagram);
      GNAT.Sockets.Set_Socket_Option(Self.Client, GNAT.Sockets.Socket_Level, (GNAT.Sockets.Reuse_Address, True));
      GNAT.Sockets.Set_Socket_Option(Self.Client, GNAT.Sockets.Socket_Level, (GNAT.Sockets.Receive_Timeout, Timeout => 1.0));
      
      GNAT.Sockets.Bind_Socket(Self.Client, Self.Address);
      
      Self.Channel := GNAT.Sockets.Stream(Self.Client, Server_Addr);
      
   end init;
   
   procedure init(Self : in out udp_sockets_type; Addr : in String; Port : in Integer) is
      Server_Addr : GNAT.Sockets.Sock_Addr_Type;
   begin
      GNAT.Sockets.Initialize;
      Self.Address.Addr :=  GNAT.Sockets.Inet_Addr (Addr);
      Self.Address.Port := GNAT.Sockets.Port_Type(Port);
      GNAT.Sockets.Create_Socket(Self.Client, GNAT.Sockets.Family_Inet, GNAT.Sockets.Socket_Datagram);
      GNAT.Sockets.Set_Socket_Option(Self.Client, GNAT.Sockets.Socket_Level, (GNAT.Sockets.Reuse_Address, True));
      GNAT.Sockets.Set_Socket_Option(Self.Client, GNAT.Sockets.Socket_Level, (GNAT.Sockets.Receive_Timeout, Timeout => 1.0));
      
      GNAT.Sockets.Bind_Socket(Self.Client, Self.Address);
      Server_Addr.Addr := Self.Address.Addr;
      Server_Addr.Port := 60002;
      Self.Channel := GNAT.Sockets.Stream(Self.Client, Server_Addr);
      
   end init;
   
   procedure write (Self : in out udp_sockets_type; 
                    Str  : in String) is
   begin
      String'Write (Self.Channel, "From Ada: " & Str);
   end write;
   
   procedure read(Self : in out udp_sockets_type) is
      use type Ada.Streams.Stream_Element_Count;
      
      Data : Ada.Streams.Stream_Element_Array (1 .. 512);
      Offset : Ada.Streams.Stream_Element_Count;
   begin
      GNAT.Sockets.Receive_Socket(Self.Client, Data, Offset);
      declare
         subtype str is String(Integer(Data'First) .. Integer(Offset));
         subtype arr is Ada.Streams.Stream_Element_Array(Data'First .. Offset);
         function magic is new Ada.Unchecked_Conversion(arr,str);
      begin
         Ada.Text_IO.Put_Line(magic(Data(Data'First .. Offset)));
      end;
   exception
      when GNAT.Sockets.Socket_Error =>
         Ada.Text_IO.Put_Line ("Nothing Received!");
   end read;
   
end udp_sockets;
