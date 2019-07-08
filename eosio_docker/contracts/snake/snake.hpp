#include <eosiolib/eosio.hpp>

using namespace std;

class snake : public eosio::contract {

    public: 

        enum game_status: uint8_t {
            ONGOING   = 0,
            SCORE = 0
        };

        struct snake_info {
            vector<uint16_t> position;
        };

        struct block_info {
            uint16_t value;
        };

        struct prey_info {
            uint16_t position;
        };

        struct preyspecial_info {
            uint16_t position;
            uint16_t score;
            uint16_t timePrey;
        };

        struct game_info {
            vector<block_info> mblocks;
            snake_info snake;
            prey_info prey;
            uint16_t numbers = 0;
            preyspecial_info preySpecial;
            bool showPreySpecial = 0;
            bool checkEat = 0;
            uint16_t score;
            uint16_t go;
            bool die = 0;
        };
        
        // @abi table users
        struct user_info {
            account_name username;
            game_info game;
            auto primary_key() const { return username; }
        };

        typedef eosio::multi_index<N(users), user_info> users_table;
        typedef eosio::multi_index<N(games), game_info> games_table;

        users_table _users;
        games_table _games;
      
        snake(account_name self): contract( self ),_users(self, self),_games(self, self){}
        
        void setupfirst(account_name username);
        uint16_t rander(uint16_t a, uint16_t b);
        void login(account_name username);
        void registeruser(account_name username);
        void blocknew(account_name username);
        void updatescore(uint16_t value, account_name username);
        void updatego(uint16_t value, account_name username);
        void createprey(vector<uint16_t> snake,account_name username);
        void special(vector<uint16_t> snake, account_name username);
        void updategame(vector<uint16_t> snake, uint16_t go, uint16_t score, account_name username);

};