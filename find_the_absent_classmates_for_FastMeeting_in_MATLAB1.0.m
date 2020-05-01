import java.awt.Robot;
import java.awt.event.*;
robot = java.awt.Robot;

load ('members.mat');%'members.mat'->members
num = length(members);
members = zeros(num);
whitelist = [ 3 , 19 , 29 ];        %设置白名单
hello_yes = '来上课了';     %出席提示语
hello_no = '没来!';         %缺席提示语
pause(7);                  %等待手动设置焦点

fprintf ('统计开始;%s\n',datetime);
for n = 1 : num
    
    for m = 1 : length(whitelist)
        if n == whitelist(m)
            continue_ = 1;
            break;
        else
            continue_ = 0;
        end
    end
    if continue_ == 1
        continue;
    end
    
    robot.mouseMove(55,160);
    robot.mousePress(InputEvent.BUTTON1_MASK);
    pause(0.1);
    robot.mouseRelease(InputEvent.BUTTON1_MASK);
    
    clipboard('copy',cell2mat(members(n)));
    robot.keyPress    (java.awt.event.KeyEvent.VK_CONTROL);%按住Ctrl
    robot.keyPress    (java.awt.event.KeyEvent.VK_A);      %按住a
    robot.keyRelease  (java.awt.event.KeyEvent.VK_A);      %松开a
    robot.keyPress    (java.awt.event.KeyEvent.VK_V);      %按住v
    robot.keyRelease  (java.awt.event.KeyEvent.VK_V);      %松开v
    robot.keyRelease  (java.awt.event.KeyEvent.VK_CONTROL);%松开Crtl
    robot.keyPress    (java.awt.event.KeyEvent.VK_ENTER);  %按住回车键
    pause(0.1);
    robot.keyRelease  (java.awt.event.KeyEvent.VK_ENTER);  %松开回车键
    pause(0.1);
    
    t = java.awt.Toolkit.getDefaultToolkit();
    rec = java.awt.Rectangle(t.getScreenSize());
    image = robot.createScreenCapture(rec);
    filehandle = java.io.File('image.png');
    javax.imageio.ImageIO.write(image,'png',filehandle);
    screen = imread('image.png');
    
    if min( [ screen(184,137,:) , screen(183,137,:) , screen(185,137,:) ] )<200
        members_(n) = 1;
        fprintf ('<%d> %s %s \n', n , cell2mat(members(n)) , hello_yes );
    else
        members_(n) = 0;
        fprintf ('<%d> %s %s \n', n , cell2mat(members(n)) , hello_no );
    end
    pause(0.1);
end
fprintf ('统计结束;%s\n',datetime);
fprintf ('出勤：%d人,未出勤：%d人，白名单：%d人。\n', sum(members_) , length(members)-sum(members_)-length(whitelist) , length(whitelist) );