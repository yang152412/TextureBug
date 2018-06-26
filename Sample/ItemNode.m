//
//  ItemNode.m
//  Sample
//
//  Copyright (c) 2014-present, Facebook, Inc.  All rights reserved.
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree. An additional grant
//  of patent rights can be found in the PATENTS file in the same directory.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
//  FACEBOOK BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
//  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ItemNode.h"

@implementation ItemNode

- (instancetype)initWithString:(NSString *)string
{
  self = [super init];
  
  if (self != nil) {
    self.text = string;
    [self updateBackgroundColor];
    
    self.textNode = [[ASTextNode alloc] init];
    
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:12],
                                NSForegroundColorAttributeName: [UIColor redColor]
                                };
    ASMutableAttributedStringBuilder *builder = [[ASMutableAttributedStringBuilder alloc] initWithString:self.text
                                                                                              attributes:attribute];
    self.textNode.attributedText = builder.composedAttributedString;
    [self addSubnode:self.textNode];
    
    self.imageNode = [[ASNetworkImageNode alloc] initWithCache:[ASPINRemoteImageDownloader sharedDownloader] downloader:[ASPINRemoteImageDownloader sharedDownloader]];
    self.imageNode.shouldCacheImage = NO;
    self.imageNode.delegate = self;
    [self.imageNode setNeedsDisplayWithCompletion:^(BOOL canceled) {
      
    }];
    __weak typeof(self) weak_self = self;
    [self.imageNode setWillDisplayNodeContentWithRenderingContext:^(CGContextRef  _Nonnull context, id  _Nullable drawParameters) {
      NSLog(@"\n ##### setWillDisplayNodeContentWithRenderingContext: %@; \n",weak_self.imageNode.URL);
      UIImage *image = [drawParameters valueForKeyPath:@"_image"];
      NSData *imageData = UIImagePNGRepresentation(image);
      NSLog(@"\n #####  setWillDisplayNodeContentWithRenderingContext image: %@, data:%@\n",image,imageData);
    }];
    [self.imageNode setDidDisplayNodeContentWithRenderingContext:^(CGContextRef  _Nonnull context, id  _Nullable drawParameters) {
      NSLog(@"\n ##### setWillDisplayNodeContentWithRenderingContext: %@; \n",weak_self.imageNode.URL);
      UIImage *image = [drawParameters valueForKeyPath:@"_image"];
      NSData *imageData = UIImagePNGRepresentation(image);
      NSLog(@"\n #####  setWillDisplayNodeContentWithRenderingContext image: %@, data:%@\n",image,imageData);
    }];
    if ([string hasPrefix:@"http"]) {
//      self.imageNode.defaultImage = [UIImage imageNamed:@"HomeIconDefault"];
      self.imageNode.defaultImage = nil;
      self.imageNode.URL = [NSURL URLWithString:string];
      
      [self addSubnode:self.imageNode];
    }
  }
  
  return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
  self.imageNode.style.preferredSize = CGSizeMake(170, 70);
  ASCenterLayoutSpec *centerLayout = [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringX sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:self.imageNode];
  ASStackLayoutSpec *stackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:10 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsCenter children:@[centerLayout, self.textNode]];
  return stackLayout;
}

- (void)updateBackgroundColor
{
  if (self.highlighted) {
    self.backgroundColor = [UIColor grayColor];
  } else if (self.selected) {
    self.backgroundColor = [UIColor darkGrayColor];
  } else {
    self.backgroundColor = [UIColor lightGrayColor];
  }
}

- (void)setSelected:(BOOL)selected
{
  [super setSelected:selected];
  
  [self updateBackgroundColor];
}

- (void)setHighlighted:(BOOL)highlighted
{
  [super setHighlighted:highlighted];
  
  [self updateBackgroundColor];
}

- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image info:(ASNetworkImageLoadInfo *)info
{
  NSLog(@"image:%@,%@",image,info);
}
- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image
{
  NSLog(@"image:%@,",image);
}
- (void)imageNodeDidStartFetchingData:(ASNetworkImageNode *)imageNode
{
  
}
- (void)imageNode:(ASNetworkImageNode *)imageNode didFailWithError:(NSError *)error
{
  NSLog(@"image:%@,%@",imageNode,error);
}
- (void)imageNodeDidFinishDecoding:(ASNetworkImageNode *)imageNode
{
  NSLog(@"image:%@,%@",imageNode,imageNode.image);
}

@end
