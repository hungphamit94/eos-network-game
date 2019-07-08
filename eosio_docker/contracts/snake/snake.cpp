#include "snake.hpp"
#include <ctime>
#include <cstdlib>
#include <iostream>
#include <eosiolib/eosio.hpp>
#include <eosiolib/print.hpp>
#include <stdio.h>
#include <eosiolib/transaction.hpp>
#include <eosiolib/dispatcher.hpp>
#include <eosiolib/crypto.h>
#include <sstream>
#include <vector>
#include <string>

uint16_t timePrey;
uint16_t timeFirst;

uint16_t snake::rander(uint16_t a, uint16_t b) {
    checksum256 result;
    auto mixedBlock = tapos_block_prefix() * tapos_block_num();

    const char *mixedChar = reinterpret_cast<const char *>(&mixedBlock);
    sha256( (char *)mixedChar, sizeof(mixedChar), &result);
    const char *p64 = reinterpret_cast<const char *>(&result);
    auto r = 0;
    for(int i = 0; i<6; i++) {
        r = (abs((int64_t)p64[i]) % (b + 1 - a)) + a;
    }
    return r;
}

void snake::login(account_name username) {
  // Ensure this action is authorized by the player
  require_auth(username);

  // Create a record in the table if the player doesn't exist in our app yet
  auto user_iterator = _users.find(username);
  if (user_iterator == _users.end()) {
    user_iterator = _users.emplace(username,  [&](auto& new_user) {
      new_user.username = username;
    });
  }
}

void snake::registeruser(account_name username){
    
    auto user_iterator = _users.emplace(username,  [&](auto& new_user) {
      new_user.username = username;
    });
}

// void snake::register(account_name username){

// }

void snake::setupfirst(account_name username){

    require_auth(username);

    auto& user = _users.get(username, "User doesn't exist");
     
    _users.modify(user, username, [&](auto& modified_user) {
        // Create a new game
        snake::game_info game;
        // Draw 4 cards each for the player and the AI
        game.go = snake::rander(0,3);
        game.snake.position.clear();
        uint16_t start = snake::rander(0,599);
        switch (game.go){
            case 0: 
                game.snake.position.push_back(284);
                game.snake.position.push_back(314);
                game.snake.position.push_back(344);
                break;
            case 1: 
                game.snake.position.push_back(284);
                game.snake.position.push_back(285);
                game.snake.position.push_back(286);
                break;
            case 2: 
                game.snake.position.push_back(284);
                game.snake.position.push_back(254);
                game.snake.position.push_back(224);
                break;
            case 3: 
                game.snake.position.push_back(284);
                game.snake.position.push_back(283);
                game.snake.position.push_back(282);
                break;
            default: 
                game.snake.position.push_back(284);
                game.snake.position.push_back(314);
                game.snake.position.push_back(344);
                break;                   
        }
        do{
            game.prey.position =  snake::rander(0,599);
        }while(std::find(game.snake.position.begin(), game.snake.position.end(), game.prey.position) != game.snake.position.end());
        
        for (uint16_t i = 0; i < 600; i++) {
            snake::block_info block;
            if(i==game.prey.position){
                block.value = 2;           
            }else if(std::find(game.snake.position.begin(), game.snake.position.end(), i) != game.snake.position.end()){
                block.value = 1;
            }else {
                block.value = 0;
            }
            game.mblocks.push_back(block);
        }
        uint16_t timeRandom = 20;
        game.preySpecial.timePrey = timeRandom;
        timeFirst = timeRandom;

        modified_user.game = game;
    });
}

void snake::createprey(vector<uint16_t> snake, account_name username){
    
    require_auth(username);

     auto& user = _users.get(username, "User doesn't exist");

    _users.modify(user, username, [&](auto& modified_user) {

        snake::game_info game = modified_user.game;
        game.snake.position.clear();
        game.snake.position = snake;

        do{                 
            game.prey.position =  snake::rander(0,599);
        }while(std::find(game.snake.position.begin(), game.snake.position.end(), game.prey.position) != game.snake.position.end());

        modified_user.game = game;

    });

}

void snake::special(vector<uint16_t> snake, account_name username){
    
    require_auth(username);

    auto& user = _users.get(username, "User doesn't exist");

    _users.modify(user, username, [&](auto& modified_user) {

        snake::game_info game = modified_user.game;
        game.snake.position.clear();
        game.snake.position = snake;

        do{
            game.preySpecial.position =  snake::rander(0,599);
        }while(std::find(game.snake.position.begin(), game.snake.position.end(), game.preySpecial.position) != game.snake.position.end());

        modified_user.game = game;

    });
}

void snake::updategame(vector<uint16_t> snake, uint16_t go, uint16_t score,account_name username){
    
    require_auth(username);
    auto& user = _users.get(username, "User doesn't exist");

    _users.modify(user, username, [&](auto& modified_user) {

        snake::game_info game = modified_user.game;
        game.snake.position.clear();
        game.snake.position = snake;
        game.go = go;
        game.score = score;

        modified_user.game = game;

    });

}

void snake::updatego(uint16_t value, account_name username){

    require_auth(username);

    auto& user = _users.get(username, "User doesn't exist");

    _users.modify(user, username, [&](auto& modified_user) {

        modified_user.game.go = value;

    });
}

void snake::updatescore(uint16_t value, account_name username){

    require_auth(username);

    auto& user = _users.get(username, "User doesn't exist");

    _users.modify(user, username, [&](auto& modified_user) {

        modified_user.game.score += value;

    });
}

void snake::blocknew(account_name username){

    require_auth(username);

    auto& user = _users.get(username, "User doesn't exist");

    _users.modify(user, username, [&](auto& modified_user) {
        // Create a new game
        snake::game_info game = modified_user.game;

        game.mblocks.clear();
        vector<uint16_t> oldSnakePosition = game.snake.position;
        vector<uint16_t> newSnakePosition;
        switch(game.go){
            case 0: 
                if(oldSnakePosition[0]-30<0){
                    game.die = 1;
                    break;
                }
                newSnakePosition.push_back(oldSnakePosition[0]-30);
                break;
            case 1:
                if(oldSnakePosition[0]%30==0){
                    game.die = 1;
                    break;
                } 
                newSnakePosition.push_back(oldSnakePosition[0]-1);
                break; 
            case 2: 
                if(oldSnakePosition[0]+30>599){
                    game.die = 1;
                    break;
                } 
                newSnakePosition.push_back(oldSnakePosition[0]+30);
                break;
            case 3: 
                if((oldSnakePosition[0]+1)%30==0){
                    game.die = 1;
                    break;
                } 
                newSnakePosition.push_back(oldSnakePosition[0]+1);
                break;
            default: 
                if(oldSnakePosition[0]-30<0){
                    game.die = 1;
                    break;
                }
                newSnakePosition.push_back(oldSnakePosition[0]-30);
                break;
        }
        if(!game.die){
            for(uint16_t i=0;i<oldSnakePosition.size()-1;i++){
                newSnakePosition.push_back(oldSnakePosition[i]);
            }
            if(game.showPreySpecial){
            if(std::find(game.snake.position.begin(), game.snake.position.end(), game.preySpecial.position) != game.snake.position.end()){
                game.checkEat = 1;
                game.showPreySpecial = 0;
                // this.setState({score: this.state.score+this.state.scorePreySpecial});
                game.score = game.score + game.preySpecial.score;
                do{
                   
                    game.prey.position =  snake::rander(0,599);
                }while(std::find(game.snake.position.begin(), game.snake.position.end(), game.prey.position) != game.snake.position.end());
            }
            }else{
                if(std::find(game.snake.position.begin(), game.snake.position.end(), game.prey.position) != game.snake.position.end()){
                    game.checkEat = 1;
                    game.score +=5; 
                    game.numbers +=1; 
                    if(game.numbers%2==0){
                        do{
                            game.preySpecial.position =  snake::rander(0,599);
                        }while(std::find(game.snake.position.begin(), game.snake.position.end(), game.preySpecial.position) != game.snake.position.end());
                        game.showPreySpecial=1;
                    }else {
                        do{
                            
                            game.prey.position =  snake::rander(0,599);
                        }while(std::find(game.snake.position.begin(), game.snake.position.end(), game.prey.position) != game.snake.position.end());
                    }
                }
            }
            if(game.checkEat){
                newSnakePosition.push_back(oldSnakePosition[oldSnakePosition.size()-1]);
                game.checkEat = 0;
            }
            
            game.snake.position = newSnakePosition;
            for (uint16_t i = 0; i < 600; i++) {
                snake::block_info block;   
                if(game.showPreySpecial&&i==game.preySpecial.position){
                    block.value = 2;   
                    game.mblocks.push_back(block);
                    if(game.preySpecial.timePrey == 0){
                        game.showPreySpecial = 0;
                        do{
                            game.prey.position =  snake::rander(0,599);
                        }while(std::find(game.snake.position.begin(), game.snake.position.end(), game.prey.position) != game.snake.position.end());
                        game.preySpecial.timePrey = 20;
                        game.preySpecial.score = 3000;
                    }else{
                        game.preySpecial.timePrey -=1;
                        game.preySpecial.score = 3000-(20-game.preySpecial.timePrey)*15;
                    }
                        
                } else if(!game.showPreySpecial&&i==game.prey.position){
                    block.value = 1;
                    game.mblocks.push_back(block);
                } else if(std::find(game.snake.position.begin(), game.snake.position.end(), i) != game.snake.position.end()){
                    block.value = 2;
                    game.mblocks.push_back(block);
                } else {
                    block.value = 0;
                    game.mblocks.push_back(block);
                }
            }
        }
        modified_user.game = game;
    });
}



EOSIO_ABI(snake, (setupfirst)(updatego)(blocknew)(login)(updatescore)(createprey)(special)(updategame)(registeruser))