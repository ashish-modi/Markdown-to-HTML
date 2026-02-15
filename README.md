# Markdown-to-HTML

A simple **Markdown to HTML conversion tool** that converts Markdown (`.md`) files into corresponding HTML output using a lexer–parser based approach.

This project is primarily intended for **learning and academic purposes**, demonstrating how Markdown syntax can be parsed and translated into HTML using **Flex (Lex)** and **Bison (Yacc)**.

---

## 🧠 Project Description

The tool works by:
1. Tokenizing Markdown input using a lexer
2. Parsing tokens using grammar rules
3. Generating equivalent HTML output

It follows a compiler-style workflow and is useful for understanding parsing, syntax analysis, and basic code generation.

---

## 📂 Repository Structure

```
Markdown-to-HTML/
├── Makefile        # Build instructions
├── bsn.y           # Bison/Yacc grammar file
├── lexx.l          # Flex/Lex lexer rules
├── run.sh          # Script to build and run the converter
├── test1.md        # Sample Markdown input file
├── logo.png        # logo
├── wiki.png        # Example output / illustration
└── README.md       # Project documentation
```

---

## ✨ Features

- Converts a subset of Markdown syntax to HTML
- Uses Flex for lexical analysis
- Uses Bison/Yacc for syntax parsing
- Demonstrates compiler construction concepts
- Simple and modular design

---

## 🛠 Requirements

Make sure the following tools are installed:

- `flex` 
- `bison` (version 3.x recommended)
- `gcc` or any C compiler
- `make`
- Linux / macOS / Windows 

---

## ⚙️ Build Instructions

To build the project, run:

```bash
make
```

This will:
- Generate lexer and parser code
- Compile the source files
- Produce an executable

---

## ▶️ Usage

You can convert a Markdown file to HTML using:

```bash
./run.sh test1.md output.html
```

---

## 📄 Example

Markdown input:
```
# Hello World
This is a sample Markdown file.
```

Generated HTML:
```html
<h1>Hello World</h1>
<p>This is a sample Markdown file.</p>
```

Supported Markdown:

- Headings (#)
- Bold (**)
- Italics (*)
- Links
- Images
- Ordered lists
- Unordered lists
- Tables
