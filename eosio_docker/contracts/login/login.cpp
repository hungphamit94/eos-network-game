#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>

using namespace eosio;

class login :  public eosio::contract {
  private:
      struct user_info {
          name            username;
          auto primary_key() const { return username.value; }
      }
      typedef eosio::multi_index<name("users"), user_info> users_table;
  public:
       
      void loginname( name user ):contract(user) {
         print( "Hello, ", user);
      }
};

EOSIO_ABI(login, (loginname))
