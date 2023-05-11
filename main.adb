with Socket_Layer;
with Ada.Streams;

procedure Main is

   Server : Socket_Layer.Socket_Type := Socket_Layer.Setup_Server;
   Item   : Ada.Streams.Stream_Element_Array(1 .. 1024);
   Last   : Ada.Streams.Stream_Element_Offset;
   From   : Socket_Address_Type;
begin

   Socket_Layer.Receive_Datagram(Server, Item, Last, From);

end Main;
