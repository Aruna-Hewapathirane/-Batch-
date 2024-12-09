unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Graphics, Controls, ExtCtrls, Buttons, StdCtrls,
  Process;

type

  { TForm1 }

  TForm1 = class(TForm)
    BackgroundImage1: TImage;
    BackgroundImage2: TImage;
    BackgroundImage3: TImage;
    Button1: TButton;
    Bullet: TImage;
    Score: TLabel;
    ship: TImage;
    Timer: TTimer;
    PlayerTimer: TTimer;
    TimerBullet: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure PlayerTimerTimer(Sender: TObject);
    procedure shipMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TimerBulletTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
    BackgroundWidth: Integer;
    procedure PlaySound(const FileName: string);
    procedure MovePlayer(Key: Word);
    procedure FireBullet;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  Bullet: TImage;  // The Bullet
  BulletFired: Boolean = False;  // Track if a bullet has been fired


implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

  Score.Caption:='SCORE:0000';
  PlaySound('assets/bgm2.wav');
  // Load the background image
    BackgroundImage1 := TImage.Create(Self);
    BackgroundImage1.Parent := Self;
    BackgroundImage1.Picture.LoadFromFile('/home/aruna/phaser-ce-coding-tips-master/issue-007/assets/predator.jpg');  // Change to your image path
    BackgroundImage1.Align := alNone;
    BackgroundImage1.Top := 0;
    BackgroundImage1.Left := 0;
    BackgroundImage1.Height:=386;
    BackgroundImage1.Width:=1600;



  // Create a second image that will loop
  BackgroundImage2 := TImage.Create(Self);
  BackgroundImage2.Parent := Self;
  BackgroundImage2.Picture.LoadFromFile('/home/aruna/phaser-ce-coding-tips-master/issue-007/assets/predator.jpg');  // Same image for seamless scrolling
  BackgroundImage2.Align := alNone;
  BackgroundImage2.Top := 0;
  BackgroundImage2.Height:=386;
  BackgroundImage2.Width:=1600;
  BackgroundImage2.Left := BackgroundImage1.Width; // Position it right next to the first image

   // Load the ship image
   // The order you load determines how and where imag eis displayed
   // Ship is displayed between far background and paralax near back ground becaue we load ship HERE !
    ship := TImage.Create(Self);
    ship.Parent := Self;
    ship.Picture.LoadFromFile('/home/aruna/phaser-ce-coding-tips-master/issue-007/assets/ship.png');  // Change to your image path
    ship.Align := alNone;
    ship.Top := 200;
    ship.Left := 100;


  // Load the background image
    BackgroundImage3 := TImage.Create(Self);
    BackgroundImage3.Parent := Self;
    BackgroundImage3.Picture.LoadFromFile('/home/aruna/phaser-ce-coding-tips-master/issue-007/assets/fore.png');  // Change to your image path
    BackgroundImage3.Align := alNone;
    BackgroundImage3.Top := 0;
    BackgroundImage3.Left := 1600;
    BackgroundImage3.Height:=386;
    BackgroundImage3.Width:=960;


  // Enable the form to capture keyboard input
//  Form1.KeyPreview := True;

  // Set the background width for reference
  BackgroundWidth := BackgroundImage1.Width;
  writeln('width:',BackgroundWidth);

  // Set form size based on the background
//  Width := BackgroundWidth * 2;  // Adjust based on desired width
  Height := BackgroundImage1.Height;

  // Start the timer to update the background position
  Timer := TTimer.Create(Self);
  Timer.Interval := 50;  // Update every 10ms for smooth scrolling
  Timer.OnTimer := @TimerTimer;
  Timer.Enabled := True;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  // Call MovePlayer when an arrow key is pressed
  MovePlayer(Key);

    // Fire bullet when spacebar is pressed
  if Key = 32 then  // 32 is the ASCII value for the spacebar
  begin
//      writeln('fire bulet');
    FireBullet;
  end;

end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  ship.Left:=X;
  ship.Top:=Y;
end;

procedure TForm1.PlayerTimerTimer(Sender: TObject);
begin

end;

procedure TForm1.shipMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  writeln(X,Y);
  ship.Left:=X;
  ship.Top:=Y;
end;

procedure TForm1.TimerBulletTimer(Sender: TObject);
begin
  // Move the bullet to the right
  if Bullet.Left < Form1.Width then  // Bullet should move right until it reaches the form's right edge
  begin
    Bullet.Left := Bullet.Left + 5;  // Adjust the speed of the bullet (move to the right)
  end
  else
  begin
    // When the bullet goes off-screen (right side), stop moving it and reset
    Bullet.Free;  // Remove the bullet from the form
    BulletFired := False;  // Allow firing another bullet
    TimerBullet.Enabled := False;  // Stop the timer
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   PlaySound('assets/bgm.wav')

end;

procedure TForm1.TimerTimer(Sender: TObject);
begin
  // Move the background images to the left
  BackgroundImage1.Left := BackgroundImage1.Left - 1;
  BackgroundImage2.Left := BackgroundImage2.Left - 1;
  BackgroundImage3.Left := BackgroundImage3.Left - 2;

  // If the first image goes off the screen, reset it to the right
  if BackgroundImage1.Left <= -BackgroundWidth then
    BackgroundImage1.Left := BackgroundWidth;

  // If the second image goes off the screen, reset it to the right
  if BackgroundImage2.Left <= -BackgroundWidth then
    BackgroundImage2.Left := BackgroundWidth;

   // If the third image goes off the screen, reset it to the right
  if BackgroundImage3.Left <= -backgroundImage3.Width then
    BackgroundImage3.Left := BackgroundWidth;



end;

procedure TForm1.MovePlayer(Key: Word);
begin
  case Key of
    37: ship.Left := ship.Left - 3; // Left Arrow
    39: ship.Left := ship.Left + 3; // Right Arrow
    38: ship.Top := ship.Top - 3;  // Up Arrow
    40: ship.Top := ship.Top + 3;  // Down Arrow
  end;
//  writeln(key);
end;


procedure TForm1.PlaySound(const FileName: string);
var
  ProcessPlayer: TProcess;
begin
  ProcessPlayer := TProcess.Create(nil);
  try
    ProcessPlayer.Executable := 'aplay';
    ProcessPlayer.Parameters.Add(FileName);
//    ProcessPlayer.Options := [poWaitOnExit];
    ProcessPlayer.Execute;
  finally
    ProcessPlayer.Free;
  end;
end;

procedure TForm1.FireBullet;
var
  count:Integer;

begin

// Only fire a bullet if none is already fired
  if not BulletFired then
  begin
    // Create the bullet image
     Bullet := TImage.Create(Self);
     Bullet.Parent := Self;  // Set the parent to the form
     Bullet.Picture.LoadFromFile('/home/aruna/phaser-ce-coding-tips-master/issue-007/assets/bullet10.png');  // Replace with your bullet image
     Bullet.AutoSize := True;

    // Position the bullet at the tip of the player's ship (to the right)
    Bullet.Top := ship.Top + 5; //ship.Top + (ship.Height div 2) + (Bullet.Height div 2);  // Vertically centered on the player ship
    writeln('BulletTop:',Bullet.Top,'shop.top:',ship.top,'shipheight/2',ship.Height div 2);
    Bullet.Left := ship.Left + 15;//(ship.Width div 2);  // Place it just to the right of the player ship

    // Set the bullet as fired
    BulletFired := True;
    Score.Caption:=inttostr(count+1);
    writeln(count);

    // Enable the timer to move the bullet
    TimerBullet.Enabled := True;
  end;
end;

end.

