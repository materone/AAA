//
//  ViewController.m
//  AAA
//
//  Created by tony on 13-11-21.
//  Copyright (c) 2013年 tony. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

char * ConvertEnc( char *encFrom, char *encTo, const char *in)
{
    
    static char  bufout[1024], *sin, *sout;
    size_t lenin, lenout, ret;
    iconv_t c_pt;
    
    if ((c_pt = iconv_open(encTo, encFrom)) == (iconv_t)-1)
    {
#ifdef _DEBUG_XML_
        printf("iconv_open false: %s ==> %s\n", encFrom, encTo);
#endif
        return NULL;
    }
    iconv(c_pt, NULL, NULL, NULL, NULL);
    lenin  = strlen(in) + 1;
    lenout = 1024;
    sin    = (char *)in;
    sout   = bufout;
    ret = iconv(c_pt, &sin, (size_t *)&lenin, &sout, (size_t *)&lenout);
    if (ret == -1)
    {
        return NULL;
    }
    iconv_close(c_pt);
    return bufout;
    
}


- (IBAction)goDraw:(id)sender {
    NSLog(@"Test");
    
    FILE* fphzk = NULL;
    int i, j, k, offset;
    int flag;
    unsigned char buffer[32];
    const char * word = "谭";
    const char * gbWord="";
    unsigned char key[8] = {
        0x80,0x40,0x20,0x10,0x08,0x04,0x02,0x01
    };
    NSString * fp = [[NSBundle mainBundle] pathForResource:@"HZK" ofType:@"DAT"];
    printf("PATH %s",[fp cStringUsingEncoding:1]);
    fphzk = fopen([fp cStringUsingEncoding:1], "rb");
    if(fphzk == NULL){
        fprintf(stderr, "error hzk16\n");
        return ;
    }
    gbWord = ConvertEnc("UTF-8", "GB2312", word);
    printf("%0X,%0X\n",gbWord[0]&0xFF,gbWord[1]&0xFF);
    offset = (94*(unsigned int)((unsigned int)(gbWord[0]&0xFF)-0xa0-1)+((unsigned int)(gbWord[1]&0xFF)-0xa0-1))*32;
    fseek(fphzk, offset, SEEK_SET);
    fread(buffer, 1, 32, fphzk);
    printf("{");
    for(k=0; k<32; k++){
        printf("0x%02X, ", buffer[k]);
    }
    printf("}\n");
    for(k=0; k<16; k++){
        for(j=0; j<2; j++){
            for(i=0; i<8; i++){
                flag = buffer[k*2+j]&key[i];
                printf("%s", flag?"+":" ");
            }
        }
        printf("\n");
    }
    fclose(fphzk);
    fphzk = NULL;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320.0f, 100.0f), NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextFillRect(ctx, CGRectMake(1, 1, 1, 1));
    CGContextFillRect(ctx, CGRectMake(1, 2, 1, 1));
    CGContextFillRect(ctx, CGRectMake(1, 3, 1, 1));
    [@"This is a test" drawAtPoint:CGPointMake(10, 10) withFont:[UIFont systemFontOfSize:18]];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *iv = [[UIImageView alloc] initWithImage:img];
    [iv setTag:1001];
    [self.view addSubview:iv];
    iv.center = self.view.center;
}


@end
