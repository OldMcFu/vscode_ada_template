with GNAT.Sockets;
with Ada.Streams;

package udp_sockets is
   type udp_sockets_type is tagged private;

   procedure init(Self : in out udp_sockets_type);
   procedure init(Self : in out udp_sockets_type; Addr : in String; Port : in Integer);
   procedure write(Self : in out udp_sockets_type; Str   : String) ;
   procedure read(Self : in out udp_sockets_type);
   
private
   type udp_sockets_type is tagged
      record
         Client : GNAT.Sockets.Socket_Type;
         Channel : GNAT.Sockets.Stream_Access;
         Address : GNAT.Sockets.Sock_Addr_Type;
      end record;
end udp_sockets;
