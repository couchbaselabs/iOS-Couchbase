
%%
%% Abstract Data Type functions for #dns_rec{}
%%
%% -export([msg/1, msg/2,
%%          make_msg/0, make_msg/1, make_msg/2, make_msg/3]).

%% Split #dns_rec{} into property list
%%
msg(#dns_rec{header=V1,qdlist=V2,anlist=V3,nslist=V4,arlist=V5}) ->
    [{header,V1},{qdlist,V2},{anlist,V3},{nslist,V4},{arlist,V5}].

%% Get one field value from #dns_rec{}
%%
msg(#dns_rec{header=V1}, header) ->
    V1;
msg(#dns_rec{qdlist=V2}, qdlist) ->
    V2;
msg(#dns_rec{anlist=V3}, anlist) ->
    V3;
msg(#dns_rec{nslist=V4}, nslist) ->
    V4;
msg(#dns_rec{arlist=V5}, arlist) ->
    V5;
%% Map field name list to value list from #dns_rec{}
%%
msg(#dns_rec{}, []) ->
    [];
msg(#dns_rec{header=V1}=R, [header|L]) ->
    [V1|msg(R, L)];
msg(#dns_rec{qdlist=V2}=R, [qdlist|L]) ->
    [V2|msg(R, L)];
msg(#dns_rec{anlist=V3}=R, [anlist|L]) ->
    [V3|msg(R, L)];
msg(#dns_rec{nslist=V4}=R, [nslist|L]) ->
    [V4|msg(R, L)];
msg(#dns_rec{arlist=V5}=R, [arlist|L]) ->
    [V5|msg(R, L)].

%% Generate default #dns_rec{}
%%
make_msg() ->
    #dns_rec{}.

%% Generate #dns_rec{} from property list
%%
make_msg(L) when is_list(L) ->
    make_msg(#dns_rec{}, L).

%% Generate #dns_rec{} with one updated field
%%
make_msg(header, V1) ->
    #dns_rec{header=V1};
make_msg(qdlist, V2) ->
    #dns_rec{qdlist=V2};
make_msg(anlist, V3) ->
    #dns_rec{anlist=V3};
make_msg(nslist, V4) ->
    #dns_rec{nslist=V4};
make_msg(arlist, V5) ->
    #dns_rec{arlist=V5};
%%
%% Update #dns_rec{} from property list
%%
make_msg(#dns_rec{header=V1,qdlist=V2,anlist=V3,nslist=V4,arlist=V5}, L) when is_list(L) ->
    do_make_msg(L, V1,V2,V3,V4,V5).
do_make_msg([], V1,V2,V3,V4,V5) ->
    #dns_rec{header=V1,qdlist=V2,anlist=V3,nslist=V4,arlist=V5};
do_make_msg([{header,V1}|L], _,V2,V3,V4,V5) ->
    do_make_msg(L, V1,V2,V3,V4,V5);
do_make_msg([{qdlist,V2}|L], V1,_,V3,V4,V5) ->
    do_make_msg(L, V1,V2,V3,V4,V5);
do_make_msg([{anlist,V3}|L], V1,V2,_,V4,V5) ->
    do_make_msg(L, V1,V2,V3,V4,V5);
do_make_msg([{nslist,V4}|L], V1,V2,V3,_,V5) ->
    do_make_msg(L, V1,V2,V3,V4,V5);
do_make_msg([{arlist,V5}|L], V1,V2,V3,V4,_) ->
    do_make_msg(L, V1,V2,V3,V4,V5).

%% Update one field of #dns_rec{}
%%
make_msg(#dns_rec{}=R, header, V1) ->
    R#dns_rec{header=V1};
make_msg(#dns_rec{}=R, qdlist, V2) ->
    R#dns_rec{qdlist=V2};
make_msg(#dns_rec{}=R, anlist, V3) ->
    R#dns_rec{anlist=V3};
make_msg(#dns_rec{}=R, nslist, V4) ->
    R#dns_rec{nslist=V4};
make_msg(#dns_rec{}=R, arlist, V5) ->
    R#dns_rec{arlist=V5}.


%%
%% Abstract Data Type functions for #dns_query{}
%%
%% -export([dns_query/1, dns_query/2,
%%          make_dns_query/0, make_dns_query/1, make_dns_query/2, make_dns_query/3]).

%% Split #dns_query{} into property list
%%
dns_query(#dns_query{domain=V1,type=V2,class=V3}) ->
    [{domain,V1},{type,V2},{class,V3}].

%% Get one field value from #dns_query{}
%%
dns_query(#dns_query{domain=V1}, domain) ->
    V1;
dns_query(#dns_query{type=V2}, type) ->
    V2;
dns_query(#dns_query{class=V3}, class) ->
    V3;
%% Map field name list to value list from #dns_query{}
%%
dns_query(#dns_query{}, []) ->
    [];
dns_query(#dns_query{domain=V1}=R, [domain|L]) ->
    [V1|dns_query(R, L)];
dns_query(#dns_query{type=V2}=R, [type|L]) ->
    [V2|dns_query(R, L)];
dns_query(#dns_query{class=V3}=R, [class|L]) ->
    [V3|dns_query(R, L)].

%% Generate default #dns_query{}
%%
make_dns_query() ->
    #dns_query{}.

%% Generate #dns_query{} from property list
%%
make_dns_query(L) when is_list(L) ->
    make_dns_query(#dns_query{}, L).

%% Generate #dns_query{} with one updated field
%%
make_dns_query(domain, V1) ->
    #dns_query{domain=V1};
make_dns_query(type, V2) ->
    #dns_query{type=V2};
make_dns_query(class, V3) ->
    #dns_query{class=V3};
%%
%% Update #dns_query{} from property list
%%
make_dns_query(#dns_query{domain=V1,type=V2,class=V3}, L) when is_list(L) ->
    do_make_dns_query(L, V1,V2,V3).
do_make_dns_query([], V1,V2,V3) ->
    #dns_query{domain=V1,type=V2,class=V3};
do_make_dns_query([{domain,V1}|L], _,V2,V3) ->
    do_make_dns_query(L, V1,V2,V3);
do_make_dns_query([{type,V2}|L], V1,_,V3) ->
    do_make_dns_query(L, V1,V2,V3);
do_make_dns_query([{class,V3}|L], V1,V2,_) ->
    do_make_dns_query(L, V1,V2,V3).

%% Update one field of #dns_query{}
%%
make_dns_query(#dns_query{}=R, domain, V1) ->
    R#dns_query{domain=V1};
make_dns_query(#dns_query{}=R, type, V2) ->
    R#dns_query{type=V2};
make_dns_query(#dns_query{}=R, class, V3) ->
    R#dns_query{class=V3}.


%%
%% Abstract Data Type functions for #dns_rr_opt{}
%%
%% -export([dns_rr_opt/1, dns_rr_opt/2,
%%          make_dns_rr_opt/0, make_dns_rr_opt/1, make_dns_rr_opt/2, make_dns_rr_opt/3]).

%% Split #dns_rr_opt{} into property list
%%
dns_rr_opt(#dns_rr_opt{domain=V1,type=V2,udp_payload_size=V3,ext_rcode=V4,version=V5,z=V6,data=V7}) ->
    [{domain,V1},{type,V2},{udp_payload_size,V3},{ext_rcode,V4},{version,V5},{z,V6},{data,V7}].

%% Get one field value from #dns_rr_opt{}
%%
dns_rr_opt(#dns_rr_opt{domain=V1}, domain) ->
    V1;
dns_rr_opt(#dns_rr_opt{type=V2}, type) ->
    V2;
dns_rr_opt(#dns_rr_opt{udp_payload_size=V3}, udp_payload_size) ->
    V3;
dns_rr_opt(#dns_rr_opt{ext_rcode=V4}, ext_rcode) ->
    V4;
dns_rr_opt(#dns_rr_opt{version=V5}, version) ->
    V5;
dns_rr_opt(#dns_rr_opt{z=V6}, z) ->
    V6;
dns_rr_opt(#dns_rr_opt{data=V7}, data) ->
    V7;
%% Map field name list to value list from #dns_rr_opt{}
%%
dns_rr_opt(#dns_rr_opt{}, []) ->
    [];
dns_rr_opt(#dns_rr_opt{domain=V1}=R, [domain|L]) ->
    [V1|dns_rr_opt(R, L)];
dns_rr_opt(#dns_rr_opt{type=V2}=R, [type|L]) ->
    [V2|dns_rr_opt(R, L)];
dns_rr_opt(#dns_rr_opt{udp_payload_size=V3}=R, [udp_payload_size|L]) ->
    [V3|dns_rr_opt(R, L)];
dns_rr_opt(#dns_rr_opt{ext_rcode=V4}=R, [ext_rcode|L]) ->
    [V4|dns_rr_opt(R, L)];
dns_rr_opt(#dns_rr_opt{version=V5}=R, [version|L]) ->
    [V5|dns_rr_opt(R, L)];
dns_rr_opt(#dns_rr_opt{z=V6}=R, [z|L]) ->
    [V6|dns_rr_opt(R, L)];
dns_rr_opt(#dns_rr_opt{data=V7}=R, [data|L]) ->
    [V7|dns_rr_opt(R, L)].

%% Generate default #dns_rr_opt{}
%%
make_dns_rr_opt() ->
    #dns_rr_opt{}.

%% Generate #dns_rr_opt{} from property list
%%
make_dns_rr_opt(L) when is_list(L) ->
    make_dns_rr_opt(#dns_rr_opt{}, L).

%% Generate #dns_rr_opt{} with one updated field
%%
make_dns_rr_opt(domain, V1) ->
    #dns_rr_opt{domain=V1};
make_dns_rr_opt(type, V2) ->
    #dns_rr_opt{type=V2};
make_dns_rr_opt(udp_payload_size, V3) ->
    #dns_rr_opt{udp_payload_size=V3};
make_dns_rr_opt(ext_rcode, V4) ->
    #dns_rr_opt{ext_rcode=V4};
make_dns_rr_opt(version, V5) ->
    #dns_rr_opt{version=V5};
make_dns_rr_opt(z, V6) ->
    #dns_rr_opt{z=V6};
make_dns_rr_opt(data, V7) ->
    #dns_rr_opt{data=V7};
%%
%% Update #dns_rr_opt{} from property list
%%
make_dns_rr_opt(#dns_rr_opt{domain=V1,type=V2,udp_payload_size=V3,ext_rcode=V4,version=V5,z=V6,data=V7}, L) when is_list(L) ->
    do_make_dns_rr_opt(L, V1,V2,V3,V4,V5,V6,V7).
do_make_dns_rr_opt([], V1,V2,V3,V4,V5,V6,V7) ->
    #dns_rr_opt{domain=V1,type=V2,udp_payload_size=V3,ext_rcode=V4,version=V5,z=V6,data=V7};
do_make_dns_rr_opt([{domain,V1}|L], _,V2,V3,V4,V5,V6,V7) ->
    do_make_dns_rr_opt(L, V1,V2,V3,V4,V5,V6,V7);
do_make_dns_rr_opt([{type,V2}|L], V1,_,V3,V4,V5,V6,V7) ->
    do_make_dns_rr_opt(L, V1,V2,V3,V4,V5,V6,V7);
do_make_dns_rr_opt([{udp_payload_size,V3}|L], V1,V2,_,V4,V5,V6,V7) ->
    do_make_dns_rr_opt(L, V1,V2,V3,V4,V5,V6,V7);
do_make_dns_rr_opt([{ext_rcode,V4}|L], V1,V2,V3,_,V5,V6,V7) ->
    do_make_dns_rr_opt(L, V1,V2,V3,V4,V5,V6,V7);
do_make_dns_rr_opt([{version,V5}|L], V1,V2,V3,V4,_,V6,V7) ->
    do_make_dns_rr_opt(L, V1,V2,V3,V4,V5,V6,V7);
do_make_dns_rr_opt([{z,V6}|L], V1,V2,V3,V4,V5,_,V7) ->
    do_make_dns_rr_opt(L, V1,V2,V3,V4,V5,V6,V7);
do_make_dns_rr_opt([{data,V7}|L], V1,V2,V3,V4,V5,V6,_) ->
    do_make_dns_rr_opt(L, V1,V2,V3,V4,V5,V6,V7).

%% Update one field of #dns_rr_opt{}
%%
make_dns_rr_opt(#dns_rr_opt{}=R, domain, V1) ->
    R#dns_rr_opt{domain=V1};
make_dns_rr_opt(#dns_rr_opt{}=R, type, V2) ->
    R#dns_rr_opt{type=V2};
make_dns_rr_opt(#dns_rr_opt{}=R, udp_payload_size, V3) ->
    R#dns_rr_opt{udp_payload_size=V3};
make_dns_rr_opt(#dns_rr_opt{}=R, ext_rcode, V4) ->
    R#dns_rr_opt{ext_rcode=V4};
make_dns_rr_opt(#dns_rr_opt{}=R, version, V5) ->
    R#dns_rr_opt{version=V5};
make_dns_rr_opt(#dns_rr_opt{}=R, z, V6) ->
    R#dns_rr_opt{z=V6};
make_dns_rr_opt(#dns_rr_opt{}=R, data, V7) ->
    R#dns_rr_opt{data=V7}.


%%
%% Abstract Data Type functions for #dns_rr{}
%%
%% -export([dns_rr/1, dns_rr/2,
%%          make_dns_rr/0, make_dns_rr/1, make_dns_rr/2, make_dns_rr/3]).

%% Split #dns_rr{} into property list
%%
dns_rr(#dns_rr{domain=V1,type=V2,class=V3,ttl=V4,data=V5}) ->
    [{domain,V1},{type,V2},{class,V3},{ttl,V4},{data,V5}].

%% Get one field value from #dns_rr{}
%%
dns_rr(#dns_rr{domain=V1}, domain) ->
    V1;
dns_rr(#dns_rr{type=V2}, type) ->
    V2;
dns_rr(#dns_rr{class=V3}, class) ->
    V3;
dns_rr(#dns_rr{ttl=V4}, ttl) ->
    V4;
dns_rr(#dns_rr{data=V5}, data) ->
    V5;
%% Map field name list to value list from #dns_rr{}
%%
dns_rr(#dns_rr{}, []) ->
    [];
dns_rr(#dns_rr{domain=V1}=R, [domain|L]) ->
    [V1|dns_rr(R, L)];
dns_rr(#dns_rr{type=V2}=R, [type|L]) ->
    [V2|dns_rr(R, L)];
dns_rr(#dns_rr{class=V3}=R, [class|L]) ->
    [V3|dns_rr(R, L)];
dns_rr(#dns_rr{ttl=V4}=R, [ttl|L]) ->
    [V4|dns_rr(R, L)];
dns_rr(#dns_rr{data=V5}=R, [data|L]) ->
    [V5|dns_rr(R, L)].

%% Generate default #dns_rr{}
%%
make_dns_rr() ->
    #dns_rr{}.

%% Generate #dns_rr{} from property list
%%
make_dns_rr(L) when is_list(L) ->
    make_dns_rr(#dns_rr{}, L).

%% Generate #dns_rr{} with one updated field
%%
make_dns_rr(domain, V1) ->
    #dns_rr{domain=V1};
make_dns_rr(type, V2) ->
    #dns_rr{type=V2};
make_dns_rr(class, V3) ->
    #dns_rr{class=V3};
make_dns_rr(ttl, V4) ->
    #dns_rr{ttl=V4};
make_dns_rr(data, V5) ->
    #dns_rr{data=V5};
%%
%% Update #dns_rr{} from property list
%%
make_dns_rr(#dns_rr{domain=V1,type=V2,class=V3,ttl=V4,data=V5}, L) when is_list(L) ->
    do_make_dns_rr(L, V1,V2,V3,V4,V5).
do_make_dns_rr([], V1,V2,V3,V4,V5) ->
    #dns_rr{domain=V1,type=V2,class=V3,ttl=V4,data=V5};
do_make_dns_rr([{domain,V1}|L], _,V2,V3,V4,V5) ->
    do_make_dns_rr(L, V1,V2,V3,V4,V5);
do_make_dns_rr([{type,V2}|L], V1,_,V3,V4,V5) ->
    do_make_dns_rr(L, V1,V2,V3,V4,V5);
do_make_dns_rr([{class,V3}|L], V1,V2,_,V4,V5) ->
    do_make_dns_rr(L, V1,V2,V3,V4,V5);
do_make_dns_rr([{ttl,V4}|L], V1,V2,V3,_,V5) ->
    do_make_dns_rr(L, V1,V2,V3,V4,V5);
do_make_dns_rr([{data,V5}|L], V1,V2,V3,V4,_) ->
    do_make_dns_rr(L, V1,V2,V3,V4,V5).

%% Update one field of #dns_rr{}
%%
make_dns_rr(#dns_rr{}=R, domain, V1) ->
    R#dns_rr{domain=V1};
make_dns_rr(#dns_rr{}=R, type, V2) ->
    R#dns_rr{type=V2};
make_dns_rr(#dns_rr{}=R, class, V3) ->
    R#dns_rr{class=V3};
make_dns_rr(#dns_rr{}=R, ttl, V4) ->
    R#dns_rr{ttl=V4};
make_dns_rr(#dns_rr{}=R, data, V5) ->
    R#dns_rr{data=V5}.


%%
%% Abstract Data Type functions for #dns_header{}
%%
%% -export([header/1, header/2,
%%          make_header/0, make_header/1, make_header/2, make_header/3]).

%% Split #dns_header{} into property list
%%
header(#dns_header{id=V1,qr=V2,opcode=V3,aa=V4,tc=V5,rd=V6,ra=V7,pr=V8,rcode=V9}) ->
    [{id,V1},{qr,V2},{opcode,V3},{aa,V4},{tc,V5},{rd,V6},{ra,V7},{pr,V8},{rcode,V9}].

%% Get one field value from #dns_header{}
%%
header(#dns_header{id=V1}, id) ->
    V1;
header(#dns_header{qr=V2}, qr) ->
    V2;
header(#dns_header{opcode=V3}, opcode) ->
    V3;
header(#dns_header{aa=V4}, aa) ->
    V4;
header(#dns_header{tc=V5}, tc) ->
    V5;
header(#dns_header{rd=V6}, rd) ->
    V6;
header(#dns_header{ra=V7}, ra) ->
    V7;
header(#dns_header{pr=V8}, pr) ->
    V8;
header(#dns_header{rcode=V9}, rcode) ->
    V9;
%% Map field name list to value list from #dns_header{}
%%
header(#dns_header{}, []) ->
    [];
header(#dns_header{id=V1}=R, [id|L]) ->
    [V1|header(R, L)];
header(#dns_header{qr=V2}=R, [qr|L]) ->
    [V2|header(R, L)];
header(#dns_header{opcode=V3}=R, [opcode|L]) ->
    [V3|header(R, L)];
header(#dns_header{aa=V4}=R, [aa|L]) ->
    [V4|header(R, L)];
header(#dns_header{tc=V5}=R, [tc|L]) ->
    [V5|header(R, L)];
header(#dns_header{rd=V6}=R, [rd|L]) ->
    [V6|header(R, L)];
header(#dns_header{ra=V7}=R, [ra|L]) ->
    [V7|header(R, L)];
header(#dns_header{pr=V8}=R, [pr|L]) ->
    [V8|header(R, L)];
header(#dns_header{rcode=V9}=R, [rcode|L]) ->
    [V9|header(R, L)].

%% Generate default #dns_header{}
%%
make_header() ->
    #dns_header{}.

%% Generate #dns_header{} from property list
%%
make_header(L) when is_list(L) ->
    make_header(#dns_header{}, L).

%% Generate #dns_header{} with one updated field
%%
make_header(id, V1) ->
    #dns_header{id=V1};
make_header(qr, V2) ->
    #dns_header{qr=V2};
make_header(opcode, V3) ->
    #dns_header{opcode=V3};
make_header(aa, V4) ->
    #dns_header{aa=V4};
make_header(tc, V5) ->
    #dns_header{tc=V5};
make_header(rd, V6) ->
    #dns_header{rd=V6};
make_header(ra, V7) ->
    #dns_header{ra=V7};
make_header(pr, V8) ->
    #dns_header{pr=V8};
make_header(rcode, V9) ->
    #dns_header{rcode=V9};
%%
%% Update #dns_header{} from property list
%%
make_header(#dns_header{id=V1,qr=V2,opcode=V3,aa=V4,tc=V5,rd=V6,ra=V7,pr=V8,rcode=V9}, L) when is_list(L) ->
    do_make_header(L, V1,V2,V3,V4,V5,V6,V7,V8,V9).
do_make_header([], V1,V2,V3,V4,V5,V6,V7,V8,V9) ->
    #dns_header{id=V1,qr=V2,opcode=V3,aa=V4,tc=V5,rd=V6,ra=V7,pr=V8,rcode=V9};
do_make_header([{id,V1}|L], _,V2,V3,V4,V5,V6,V7,V8,V9) ->
    do_make_header(L, V1,V2,V3,V4,V5,V6,V7,V8,V9);
do_make_header([{qr,V2}|L], V1,_,V3,V4,V5,V6,V7,V8,V9) ->
    do_make_header(L, V1,V2,V3,V4,V5,V6,V7,V8,V9);
do_make_header([{opcode,V3}|L], V1,V2,_,V4,V5,V6,V7,V8,V9) ->
    do_make_header(L, V1,V2,V3,V4,V5,V6,V7,V8,V9);
do_make_header([{aa,V4}|L], V1,V2,V3,_,V5,V6,V7,V8,V9) ->
    do_make_header(L, V1,V2,V3,V4,V5,V6,V7,V8,V9);
do_make_header([{tc,V5}|L], V1,V2,V3,V4,_,V6,V7,V8,V9) ->
    do_make_header(L, V1,V2,V3,V4,V5,V6,V7,V8,V9);
do_make_header([{rd,V6}|L], V1,V2,V3,V4,V5,_,V7,V8,V9) ->
    do_make_header(L, V1,V2,V3,V4,V5,V6,V7,V8,V9);
do_make_header([{ra,V7}|L], V1,V2,V3,V4,V5,V6,_,V8,V9) ->
    do_make_header(L, V1,V2,V3,V4,V5,V6,V7,V8,V9);
do_make_header([{pr,V8}|L], V1,V2,V3,V4,V5,V6,V7,_,V9) ->
    do_make_header(L, V1,V2,V3,V4,V5,V6,V7,V8,V9);
do_make_header([{rcode,V9}|L], V1,V2,V3,V4,V5,V6,V7,V8,_) ->
    do_make_header(L, V1,V2,V3,V4,V5,V6,V7,V8,V9).

%% Update one field of #dns_header{}
%%
make_header(#dns_header{}=R, id, V1) ->
    R#dns_header{id=V1};
make_header(#dns_header{}=R, qr, V2) ->
    R#dns_header{qr=V2};
make_header(#dns_header{}=R, opcode, V3) ->
    R#dns_header{opcode=V3};
make_header(#dns_header{}=R, aa, V4) ->
    R#dns_header{aa=V4};
make_header(#dns_header{}=R, tc, V5) ->
    R#dns_header{tc=V5};
make_header(#dns_header{}=R, rd, V6) ->
    R#dns_header{rd=V6};
make_header(#dns_header{}=R, ra, V7) ->
    R#dns_header{ra=V7};
make_header(#dns_header{}=R, pr, V8) ->
    R#dns_header{pr=V8};
make_header(#dns_header{}=R, rcode, V9) ->
    R#dns_header{rcode=V9}.

%% Record type index
%%
record_adts(#dns_rec{}) ->
    msg;
record_adts(#dns_query{}) ->
    dns_query;
record_adts(#dns_rr_opt{}) ->
    dns_rr_opt;
record_adts(#dns_rr{}) ->
    dns_rr;
record_adts(#dns_header{}) ->
    header;
record_adts(_) -> undefined.
