# 🎓 AI Foundation Workshop - Interactive Notebooks

Welcome to the AI Foundation Workshop! This hands-on learning experience will teach you how to build real AI applications using Python and modern AI models.

## 🌟 What You'll Learn

Through 7 interactive Jupyter notebooks, you'll master:

1. **💬 Text Generation** - Build conversational AI and chatbots
2. **🖼️ Multimodal AI** - Work with images and vision models
3. **📊 Structured Outputs** - Extract reliable data from text
4. **🔧 Function Calling** - Give AI access to custom tools
5. **🔌 Model Context Protocol (MCP)** - Connect AI to standardized services
6. **🧠 Reasoning Models** - Solve complex problems step-by-step
6. **🧠 Reasoning Models** - Solve complex problems step-by-step

## 🚀 Quick Start

### Prerequisites
- Python 3.10+ OR Docker
- API key (Google AI Studio recommended for beginners)

### Fast Track (5 minutes)

1. **Get your API key**: [Google AI Studio](https://aistudio.google.com/apikey)
2. **Setup & Run**:
   ```bash
   cd ai-foundation-workshop
   
   # One command to setup .env, create venv, install, and run!
   make dev
   ```
3. **Configure**: The first time you run it, it will create `.env`. **Edit `.env` and add your API key**, then run `make dev` again.
4. **Start Learning**: Open `01-text-generation.ipynb` at http://localhost:8888

## 📚 Notebook Guide

### Recommended Learning Path

Follow the notebooks in order - each builds on concepts from previous ones:

#### 🌍 Universal Topics (Work with Any AI Provider)

| Notebook | Topic | Time | What You'll Build |
|----------|-------|------|-------------------|
| **01** | Text Generation | 45 min | Restaurant chatbot with personality |
| **02** | Multimodal AI | 45 min | Menu description generator from photos |
| **03** | Structured Outputs | 60 min | Resume parser and invoice processor |
| **04** | Function Calling | 60 min | Calculator agent and weather bot |
| **05** | MCP | 60 min | Travel assistant with real-time data |
| **06** | Reasoning Models | 45 min | Math tutor and code debugger |



## 🎯 Learning Approach

Each notebook follows a consistent, beginner-friendly structure:

### 📖 Scenario-Based Learning
Every concept is introduced through real-world scenarios you can relate to.

**Example**: Instead of "learn about streaming," you'll build a chatbot where streaming makes responses feel instant.

### 🛠️ Hands-On Practice
- **Working code examples** you can run immediately
- **Discussion questions** to deepen understanding
- **Challenge tasks** to test your skills
- **Real-world applications** you can build

### 💡 Key Insights
Look for these throughout each notebook:
- **💡 Key Insight** - Important concepts explained simply
- **❓ Discussion Question** - Think critically about what you learned
- **🎯 Challenge Task** - Apply your knowledge
- **⚠️ Important Note** - Critical information to remember

## 🔑 API Keys & Models

### Supported Providers

The notebooks work with multiple AI providers:

| Provider | Models | Cost | Best For |
|----------|--------|------|----------|
| **Google (Gemini)** | gemini-2.0-flash-exp | Free tier! | Beginners, all notebooks |
| **OpenAI** | gpt-4o, gpt-4o-mini | Paid | Production apps |
| **Anthropic** | claude-3-5-sonnet | Paid | Advanced reasoning |
| **OpenRouter** | Multiple models | Varies | Model comparison |

### Getting API Keys

- **Google AI Studio** (Recommended for beginners): https://aistudio.google.com/apikey
- **OpenAI**: https://platform.openai.com/api-keys
- **Anthropic**: https://console.anthropic.com/

### Model Requirements

- **Notebooks 1, 3-6**: Any model works
- **Notebook 2 (Multimodal)**: Requires vision-enabled model
  - ✅ `gemini/gemini-2.5-flash`
  - ✅ `gpt-4o`
  - ✅ `claude-3-5-sonnet-20241022`

## 💻 Running the Notebooks

We provide a `Makefile` to make common tasks easy. Run `make help` to see all commands.

### Option 1: Local Development (Recommended)

This automatically creates a virtual environment (`.venv`), installs dependencies, and starts JupyterLab.

```bash
# 1. Setup & Install
make dev
```
**Note**: The first time you run this, it will create `.env`. **You must edit `.env` and add your API key** before the notebooks will work!

**Manual Steps (if you prefer):**
```bash
make setup      # Create .env and .venv
make install    # Install dependencies into .venv
make run        # Start JupyterLab
```

### Option 2: Docker (Isolated)

Perfect for keeping your system clean or ensuring consistency.

```bash
make setup      # Create .env (Edit to add API key)
make build      # Build image
make up         # Start container
```
- **Access**: http://localhost:8888
- **Stop**: `make down`
- **Logs**: `make logs`

### Option 3: Google Colab (Cloud)

1. Upload notebook to Google Drive
2. Open with Google Colab
3. **Recommended**: Use Colab Secrets for API keys:
   - Click the 🔑 key icon in the left sidebar
   - Add a new secret: `GOOGLE_API_KEY`
   - Paste your API key as the value
   - Uncomment the Colab secrets lines in the notebook:
     ```python
     from google.colab import userdata
     os.environ["GOOGLE_API_KEY"] = userdata.get('GOOGLE_API_KEY')
     ```

### Option 4: VS Code

1. Install the **Jupyter** extension
2. Open the notebook
3. Select Kernel -> Python Environments
4. Run cells with the play button

## 🎓 Learning Tips

### For Complete Beginners

1. **Start with Notebook 1** - Don't skip ahead!
2. **Read the scenarios** - They make concepts relatable
3. **Run every code cell** - Learning by doing is key
4. **Try the challenges** - They solidify your understanding
5. **Ask questions** - Use discussion questions to think deeper

### For Experienced Developers

1. **Skim the basics** - But don't skip the "Key Insights"
2. **Focus on challenges** - Test your understanding
3. **Experiment** - Try different models and parameters
4. **Build real apps** - Use the "Real-World Applications" as starting points

### Common Issues

**"Module not found" error**
```bash
make install
```

**"RuntimeWarning: coroutine was never awaited" (Colab/Jupyter)**
This is already fixed in the notebooks! Each notebook includes a cell that enables async support. If you still see this error:
```python
import nest_asyncio
nest_asyncio.apply()
```

**"API key not found" error**
- Check your `.env` file exists
- Verify the key is correct
- Make sure you're using the right key name (`GOOGLE_API_KEY`, etc.)

**"Model not found" error**
- Check your `DEFAULT_MODEL` in `.env`
- Verify you have the right API key for that model
- Try `gemini/gemini-2.5-flash` (free tier)

## 🏗️ What You Can Build

After completing these notebooks, you'll be able to build:

### Beginner Projects
- 💬 Customer support chatbot
- 📧 Email auto-responder
- 📝 Content summarizer
- 🖼️ Image description generator

### Intermediate Projects
- 🔍 Research assistant with web search
- 📊 Data extraction pipeline
- 🧮 Math tutoring bot
- 🐛 Code review assistant

### Advanced Projects
- 🤖 Multi-tool AI agent
- 📈 Business intelligence dashboard
- 🎯 Decision support system
- 🔬 Scientific research assistant

## 📖 Additional Resources

### Documentation
- [LiteLLM Docs](https://docs.litellm.ai/) - Multi-provider AI library
- [Google AI Studio](https://aistudio.google.com/) - Test Gemini models
- [OpenAI Docs](https://platform.openai.com/docs) - GPT models
- [Anthropic Docs](https://docs.anthropic.com/) - Claude models

### Community
- Share your projects and ask questions
- Connect with other learners
- Get help when stuck

### Next Steps
After completing these notebooks:
1. Build a real project using what you learned
2. Explore advanced topics (RAG, agents, fine-tuning)
3. Deploy your AI application to production
4. Share your learnings with others!

## 🤝 Contributing

Found a typo? Have a suggestion? Want to add an example?
- Open an issue
- Submit a pull request
- Share your feedback

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🎉 Ready to Start?

1. ✅ `make setup`
2. ✅ `make dev`
3. ✅ Open `01-text-generation.ipynb`
4. ✅ Start building!

**Happy learning! 🚀**

---

*Questions? Stuck on something? Remember: Every expert was once a beginner. Take your time, experiment, and enjoy the journey!*
