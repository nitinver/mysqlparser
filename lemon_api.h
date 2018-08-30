
void *ParseAlloc(void *(*mallocProc)(size_t));

const char *ParseTokenName(int tokenType);

void *ParseAlloc(void *(*mallocProc)(size_t));


void ParseFree( 
  void *p,                    /* The parser to be deleted */
  void (*freeProc)(void*)     /* Function used to reclaim memory */
);

void Parse(
  void *yyp,                   /* The parser */
  int yymajor,                 /* The major token code number */
  char * yyminor                /* The value for the token. */
                                // NOTE: This needs to match ParseTOKENTYPE.
);
