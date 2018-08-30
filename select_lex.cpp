#include <boost/spirit/include/support_istream_iterator.hpp>
#include <boost/spirit/include/lex_lexertl.hpp>
#include <fstream>
#include <sstream>    
#include <boost/lexical_cast.hpp>
#include <unordered_map>
#include <stdlib.h>
#include "lemon_api.h"
#include "select2.h"
#include "assert.h"
#include <sstream>
#include <string>

namespace lex = boost::spirit::lex;

using namespace std;

unordered_map<string, int> tokenMap;

enum tokenids
{
    ID_KEYWORD = boost::spirit::lex::min_token_id + 1,
    ID_DOT,
    ID_POPEN,
    ID_PCLOSE,
    ID_MATH_OPERATOR,
    ID_REL_OPERATOR,
    ID_COLON,
    ID_SEMICOLON,
    ID_COMMA,
    ID_ASSIG_OPERATOR,
    ID_BINARY_OPERATOR,
    ID_UN_OPERATOR,
    ID_NUM_FLOAT,
    ID_NUM_INTEGER,
    ID_IDENTIFIER
};

template <typename Lexer>
struct tokens : lex::lexer<Lexer>
{

    typedef boost::spirit::lex::token_def<> token_def;
    typedef boost::spirit::lex::token_def<int> token_def_int;
    typedef boost::spirit::lex::token_def<double> token_def_double;
    typedef boost::spirit::lex::token_def<string> token_def_string;

    tokens() 
    {
        ws_            = "[ \\t\\r\\n]";
        line_comment_  = "\\/\\/.*?[\\r\\n]";
        block_comment_ = "\\/\\*.*?\\*\\/";

        this->self.add_pattern
            ("SCHAR", "\\\\(x[0-9a-fA-F][0-9a-fA-F]|[\\\\\"'0tbrn])|[^\"\\\\'\\r\\n]")
            ;
        string_lit = "\\\"('|{SCHAR})*?\\\"";
        char_lit   = "'(\\\"|{SCHAR})'";

        this->self += 
            token_def ("[s|S][e|E][l|L][e|E][c|C][t|T]", PP_TOKEN_SELECT) |
            token_def ("[f|F][r|R][o|O][m|M]", PP_TOKEN_FROM) |
            token_def ("[w|W][h|H][e|E][r|R][e|E]", PP_TOKEN_WHERE) |
            token_def ("[l|L][i|I][m|M][i|I]|[t|T]", PP_TOKEN_LIMIT) |
           // token_def ("[a|A][l|L][i|I][a|A]|[s|S]", PP_TOKEN_ALIAS) |
           //     |from|where|limit|order|by|alias|and", ) | 
            token_def (',', PP_TOKEN_COMMA) | 
            token_def ('.', ID_DOT) | 
            token_def ('(', ID_POPEN) |
            token_def (')', ID_PCLOSE) |
            token_def (':', ID_COLON) |
            token_def (';', PP_TOKEN_SEMICOLON) |
            token_def ("[*+-/%]", ID_MATH_OPERATOR) |
            token_def ("==|!=|<=|>=|<|>", ID_REL_OPERATOR) |
            token_def ('=', ID_ASSIG_OPERATOR) |
            token_def_double ("[-+]?[0-9]+(e[-+]?[0-9]+)?f?", ID_NUM_FLOAT) |
            token_def_int ("[-+]?[0-9]+", PP_TOKEN_NUM_INTEGER) | 
            token_def_string ("[a-zA-Z_][a-zA-Z0-9_]*", PP_TOKEN_IDENTIFIER) | 
            string_lit | char_lit
            // ignore whitespace and comments
            | ws_           [ lex::_pass = lex::pass_flags::pass_ignore ]
            | line_comment_ [ lex::_pass = lex::pass_flags::pass_ignore ]
            | block_comment_[ lex::_pass = lex::pass_flags::pass_ignore ] 
            ;
    }

  private:
    lex::token_def<> string_lit, char_lit;
    lex::token_def<lex::omit> ws_, line_comment_, block_comment_;
};

void *pParser;

struct process_token
{
    template <typename T>
    bool operator()(T const& token) const {
     //   std::cout << "Orig\n---------" << '[' /*<< token.id() << ":" */<< print(token.value()) << "]" << endl;
        std::cout << "Dupl\n---------" << '[' << token.id() << ":";
        cout << token.value() << "]" << endl;

        switch (token.id())
        {
            case PP_TOKEN_SELECT:

                pParser = ParseAlloc (malloc);
                Parse (pParser, token.id(), 0);
                break;

            case PP_TOKEN_IDENTIFIER:

                {
                    std::stringstream ss;
                    ss << token.value();
                    std::string id_value = ss.str();
                    Parse (pParser, token.id(), (char*)id_value.c_str());
                }

                break;

            case PP_TOKEN_COMMA:
            case PP_TOKEN_WHERE:
            case PP_TOKEN_FROM:

                Parse(pParser, token.id(), 0);
                break;

            case PP_TOKEN_SEMICOLON:

                Parse(pParser, token.id(), 0);
                ParseFree(pParser, free);
                break;

            default:
                break;

        }

        return true;
    }

};

int main()
{
    //FillMap(tokenMap);

    typedef boost::spirit::istream_iterator It;
    typedef lex::lexertl::token<It, boost::mpl::vector<int, double>, boost::mpl::true_ > token_type;
    tokens<lex::lexertl::actor_lexer<token_type> > lexer;

    std::ifstream ifs("select.tests");
    ifs >> std::noskipws;
    It first(ifs), last;

    std::cout<< "\nStarting input: " << std::string(first, last) << endl;

    bool ok = lex::tokenize(first, last, lexer, process_token());

    std::cout << "\nTokenization " << (ok?"succeeded":"failed") << "; remaining input: '" << std::string(first,last) << "'\n";
}

