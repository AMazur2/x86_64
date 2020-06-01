#include <iostream>
#include <string>
#include <sstream>
#include <SFML/Graphics.hpp>
#include <SFML/Window.hpp>

extern "C" void fern(unsigned char *pixels, int height, int width, int limit1, int limit2, int limit3, int iterations);
int width = 1000;
int height = 1000;
using namespace std;

int getInteger();

int main()
{
    int limit1 = 10, limit2 = 860, limit3 = 930, iterations = 1;
    bool changed;


    sf::RenderWindow window(sf::VideoMode( width, height, 32 ), "Barnsley fern", sf::Style::Default);
    sf::Uint8 *pixels = new unsigned char[width* height * 4];
    sf::Image image;
    sf::Texture texture;
    sf::Sprite sprite;

    while(window.isOpen())
    {
        sf::Event event;
        while (window.pollEvent(event))
        {
            if(event.type == sf::Event::Closed)
                window.close();

            if(event.type == sf::Event::KeyPressed)
            {
                if(event.key.code == sf::Keyboard::Up)
                {
                    if(limit1+5 != limit2)
                        limit1 += 5;
                    cout << "Limit1 = " << limit1 << endl;
                    changed = true;
                }

                if(event.key.code == sf::Keyboard::Down)
                {
                    if(limit1 != 5)
                        limit1 -= 5;
                    cout << "Limit1 = " << limit1 << endl;
                    changed = true;
                }

                if(event.key.code == sf::Keyboard::Right)
                {
                    if(limit2 + 5 != limit3)
                        limit2 += 5;
                    cout << "Limit2 = " << limit2 << endl;
                    changed = true;
                }

                if(event.key.code == sf::Keyboard::Left)
                {
                    if(limit2 - 5 != limit1)
                        limit2 -=5;
                    cout << "Limit2 = " << limit2 << endl;
                    changed = true;
                }

                if(event.key.code == sf::Keyboard::W)
                {
                    if(limit3 + 5 != 1000)
                        limit3 += 5;
                    cout << "Limit3 = " << limit3 << endl;
                    changed = true;
                }

                if(event.key.code == sf::Keyboard::S)
                {
                    if(limit3 - 5 != limit2)
                        limit3 -= 5;
                    cout << "Limit3 = " << limit3 << endl;
                    changed = true;
                }

                if(event.key.code == sf::Keyboard::A)
                {
                    if(iterations != 1)
                        iterations /= 10;
                    cout << "Iterations = " << iterations << endl;
                    changed = true;
                }

                if(event.key.code == sf::Keyboard::D)
                {
                    if(iterations != 100000000)
                        iterations *= 10;
                    cout << "Iterations = " << iterations << endl;
                    changed = true;
                }
            }
        }

        if(changed)
        {
            for(int i = 0; i <4*width*height; ++i)
                pixels[i] = 0;
            window.clear();
            fern(pixels, height, width, limit1, limit2, limit3, iterations);
            image.create(width, height, pixels);
            texture.create(width, height);
            texture.update(image);
            sprite.setTexture(texture);
            window.draw(sprite);
            window.display();
            changed = false;
        }
    }

    return 0;
}